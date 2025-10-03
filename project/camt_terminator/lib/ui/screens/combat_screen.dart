// lib/ui/screens/combat_screen.dart
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/deck_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart' hide Card;

import 'package:camt_terminator/cubit/game_cubit.dart';
import '../../cubit/card_cubit.dart';

import '../widgets/card_widget.dart';
import '../widgets/player_widget.dart';
import '../widgets/boss_widget.dart';
import '../widgets/deck_widget.dart';

class CombatScreen extends StatefulWidget {
  const CombatScreen({super.key});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  @override
  void initState() {
    super.initState();
    GameCubit.I.reset();
    CardCubit.I.reset();

    GameCubit.I.startCombat();
    GameCubit.I.boss.drawCards();
  }

  @override
  void dispose() {
    GameCubit.I.reset(); // ensure cleanup when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/combat_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          GameCubit.I.reset();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 4),
                      ValueListenableBuilder<int>(
                        valueListenable: CardCubit.I.turnNotifier,
                        builder: (_, int turn, __) {
                          return Text(
                            'Turn: $turn',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      ValueListenableBuilder<int>(
                        valueListenable: GameCubit.I.bossKillsNotifier,
                        builder: (_, int bossKills, __) {
                          return Text(
                            'Round: ${bossKills + 1} / 4',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                /// Boss area
                ValueListenableBuilder<List<Card>>(
                  valueListenable: CardCubit.I.selectedCardsNotifier,
                  builder: (context, selected, __) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: CardCubit.I.isResolvingNotifier,
                      builder: (context, resolving, __) {
                        final isReadyToAttack =
                            selected.length == 3 && !resolving;

                        return GestureDetector(
                          onTap: isReadyToAttack
                              ? () {
                                  final player =
                                      GameCubit.I.playerNotifier.value!;
                                  CardCubit.I.playSelectedCards(
                                    player: player,
                                    boss: GameCubit.I.boss,
                                  );
                                }
                              : null,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              BossWidget(boss: GameCubit.I.boss),
                              if (isReadyToAttack)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.red.withOpacity(0.5),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Attack',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Boss's playing card
                ValueListenableBuilder<List<Card>>(
                  valueListenable: CardCubit.I.bossPlayedNotifier,
                  builder: (context, bossCards, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(bossCards.length, (index) {
                        if (index < bossCards.length) {
                          return CardWidget(card: bossCards[index]);
                        } else {
                          return const FoldedCardWidget();
                        }
                      }),
                    );
                  },
                ),

                const Spacer(),

                // Selected cards
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: ValueListenableBuilder<List<Card>>(
                      valueListenable: CardCubit.I.selectedCardsNotifier,
                      builder: (context, List<Card> selected, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            if (index < selected.length) {
                              return CardWidget(card: selected[index]);
                            } else {
                              return const EmptyCardWidget();
                            }
                          }),
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ValueListenableBuilder<Player?>(
                    valueListenable: GameCubit.I.playerNotifier,
                    builder: (context, Player? player, _) {
                      if (player == null) return const SizedBox.shrink();
                      return PlayerWidget(player: player);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: ValueListenableBuilder<List<Card>>(
                      valueListenable: CardCubit.I.handNotifier,
                      builder: (context, List<Card> hand, _) {
                        return ValueListenableBuilder<List<Card>>(
                          valueListenable: CardCubit.I.selectedCardsNotifier,
                          builder: (context, List<Card> selected, __) {
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: List.generate(5, (index) {
                                if (index < hand.length) {
                                  final card = hand[index];
                                  final isSelected = selected.contains(card);
                                  return GestureDetector(
                                    onTap: () {
                                      CardCubit.I.toggleCardSelection(card);
                                    },
                                    child: Stack(
                                      children: [
                                        CardWidget(card: card),
                                        if (isSelected)
                                          Positioned.fill(
                                            child: Container(
                                              color:
                                                  Colors.yellow.withOpacity(0.3),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const EmptyCardWidget();
                                }
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 0, top: 300),
                child: ValueListenableBuilder<Deck>(
                  valueListenable: CardCubit.I.deckNotifier,
                  builder: (context, Deck deck, _) {
                    return DeckWidget(
                      deck: deck,
                      onTap: () {
                        CardCubit.I.drawCards();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
