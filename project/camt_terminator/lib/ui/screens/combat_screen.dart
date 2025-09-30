// lib/ui/screens/combat_screen.dart
import 'package:camt_terminator/cubit/game_cubit.dart';
import 'package:camt_terminator/models/card_model.dart';
import 'package:flutter/material.dart';
import '../../cubit/card_cubit.dart';
import '../../models/player_model.dart';
import '../../models/boss_model.dart';

class CombatScreen extends StatefulWidget {
  const CombatScreen({super.key});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  final CardCubit _cubit = CardCubit();

  final Player _player = GameCubit.I.player;
  final Boss _boss = GameCubit.I.boss;

  @override
  void initState() {
    super.initState();
    _cubit.reset();
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
                  const SizedBox(width: 48), // placeholder for symmetry
                ],
              ),

              const Spacer(),

              // Card Hand
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _cubit.hand
                    .map((c) => _CardRect(label: _labelFor(c)))
                    .toList(),
              ),

              const Spacer(),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
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

  String _labelFor(dynamic c) {
    if (c is AttackCard) return 'ATK ${c.power}';
    if (c is DefenseCard) return 'DEF ${c.power}';
    if (c is MedkitCard) return 'Medkit';
    if (c is ShotgunCard) return 'Shotgun';
    return 'Card';
  }
}

// Simplified placeholder boss for now
class DummyBoss extends Boss {
  DummyBoss()
    : super(
        id: 'boss_dummy',
        name: 'Dummy',
        hp: 15,
        maxHp: 15,
        weapon: 'None',
        ability: 'None',
      );

  @override
  void useAbility(Player player) {}
}

class _CardRect extends StatelessWidget {
  final String label;
  const _CardRect({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
