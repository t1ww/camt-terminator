// project\camt_terminator\lib\ui\screens\rules_screen.dart
import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rules')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            // Put your full rules text here later
            'CAMT Terminator — Rogue-like card combat.\n\n'
            '• Draw 5 cards first turn, then 3 per turn.\n'
            '• Choose 3 cards to play.\n'
            '• Player-only consumables: Shotgun (7 dmg), Med Kit (+5 HP).\n'
            '• Def/Atk interactions as per spec.\n\n'
            '… (rest of your rules) …',
          ),
        ),
      ),
    );
  }
}
