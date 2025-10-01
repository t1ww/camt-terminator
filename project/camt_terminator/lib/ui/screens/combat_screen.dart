// lib/ui/screens/combat_screen.dart
import 'package:camt_terminator/models/boss_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';

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
  late final Player _player;
  late Boss _boss;

  @override
  void initState() {
    super.initState();
    GameCubit.I.startCombat();
    CardCubit.I.reset();
    _player = GameCubit.I.player;
    _boss = GameCubit.I.boss;
  }

  void _onBossDefeated() {
    final continued = GameCubit.I.onBossDefeated(context);
    if (!continued) return;
    setState(() => _boss = GameCubit.I.boss);
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
                      Text(
                        'Turn: ${CardCubit.I.turn}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Round: ${GameCubit.I.getRound()} / 4',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Boss area
                BossWidget(boss: _boss),

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
                  padding: const EdgeInsets.only(bottom: 20),
                  child: PlayerWidget(player: _player),
                ),

                // Player hand (bottom)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: CardCubit.I.hand
                          .map((c) => CardWidget(card: c))
                          .toList(),
                    ),
                  ),
                ),

                // (Optional) test button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: OutlinedButton(
                    onPressed: _onBossDefeated,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text('Defeat Boss (Test)'),
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
                  right: 12,
                  top: 360,
                ), // add top to push deck down
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() => CardCubit.I.drawCards());
                  },
                  child: DeckWidget(deck: CardCubit.I.deck, onTap: null),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}