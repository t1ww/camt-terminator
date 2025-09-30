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
    if (!continued) return; // Game ended, navigation handled

    setState(() {
      _boss = GameCubit.I.boss;
    });
  }

  @override
  void dispose() {
    GameCubit.I.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/combat_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    "Turn: ${CardCubit.I.turn}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "Round: ${GameCubit.I.getRound()} / 4",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 16),

              // Boss Widget
              BossWidget(boss: _boss),

              const Spacer(),

              // Player hand above player
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: CardCubit.I.hand
                          .map((c) => CardWidget(card: c))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    // Player Widget (HP + info)
                    PlayerWidget(player: _player),
                  ],
                ),
              ),

              // Deck on right-center
              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height / 2 - 50,
                child: DeckWidget(
                  deck: CardCubit.I.deck,
                  onTap: () {
                    setState(() => CardCubit.I.drawCards());
                  },
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
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
      ),
    );
  }
}
