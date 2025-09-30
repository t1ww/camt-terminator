// lib/ui/screens/combat_screen.dart
import 'package:camt_terminator/cubit/game_cubit.dart';
import 'package:camt_terminator/models/boss_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';
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
  final CardCubit _cubit = CardCubit();

  late final Player _player;
  late final Boss _boss;

  @override
  void initState() {
    super.initState();

    // Initialize player & boss using GameCubit
    _player = GameCubit.I.getPlayerInstance();
    _boss = GameCubit.I.getRandomBoss();

    GameCubit.I.player = _player;
    GameCubit.I.boss = _boss;

    _cubit.reset();
  }

  @override
  void dispose() {
    // Clean up GameCubit overlays and state
    GameCubit.I.teardownIfAny();
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
                    "Turn ${_cubit.turn}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 16),

              // Boss Widget
              BossWidget(boss: _boss),

              const Spacer(),

              // Player Hand (cards)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _cubit.hand.map((c) => CardWidget(card: c)).toList(),
              ),

              const Spacer(),

              // Deck Widget
              DeckWidget(deck: _cubit.deck),

              const SizedBox(height: 12),

              // Player Widget (HP + info)
              PlayerWidget(player: _player),

              const SizedBox(height: 16),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _cubit.drawCards());
                        },
                        child: Text(_cubit.turn == 0 ? 'Draw 5' : 'Draw 3'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _cubit.reset());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
