// lib/ui/screens/combat_screen.dart
import 'package:camt_terminator/models/boss_model.dart';
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
    GameCubit.I.startCombat();
    CardCubit.I.reset();
  }

  @override
  void dispose() {
    GameCubit.I.reset();
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

          // Main column content
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 4),
                      // Turn count (reactive)
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
                      // Round info
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

                // Boss area (reactive)
                ValueListenableBuilder<Boss?>(
                  valueListenable: GameCubit.I.bossNotifier,
                  builder: (context, Boss? boss, _) {
                    if (boss == null) return const SizedBox.shrink();
                    return BossWidget(boss: boss);
                  },
                ),
                const SizedBox(height: 16),

                // ----- Middle row: 3 empty slots (UI only) -----
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FoldedCardWidget(),
                      SizedBox(width: 12),
                      FoldedCardWidget(),
                      SizedBox(width: 12),
                      FoldedCardWidget(),
                    ],
                  ),
                ),

                const Spacer(),

                // ----- Middle row: 3 empty slots (UI only) -----
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        EmptyCardWidget(),
                        SizedBox(width: 12),
                        EmptyCardWidget(),
                        SizedBox(width: 12),
                        EmptyCardWidget(),
                      ],
                    ),
                  ),
                ),

                // Player character area (+ HP bar)
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

                // Player hand (reactive)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: ValueListenableBuilder<List<Card>>(
                      valueListenable: CardCubit.I.handNotifier,
                      builder: (context, List<Card> hand, _) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: List.generate(5, (index) {
                            if (index < hand.length) {
                              return CardWidget(card: hand[index]);
                            } else {
                              return const EmptyCardWidget();
                            }
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----- Deck on the right side (tap to draw) -----
          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                  top: 300,
                ), // Add top to push deck down
                child: ValueListenableBuilder<Deck>(
                  valueListenable: CardCubit.I.deckNotifier,
                  builder: (context, Deck deck, _) {
                    return DeckWidget(
                      deck: deck,
                      onTap: () {
                        // Draw cards and notify UI automatically
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
