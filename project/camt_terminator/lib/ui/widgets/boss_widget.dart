// lib/widgets/boss_widget.dart
import 'package:camt_terminator/models/boss_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class BossWidget extends StatelessWidget {
  final Boss boss;
  const BossWidget({required this.boss});

  @override
  Widget build(BuildContext context) {
    String asset = 'assets/images/boss1.png';
    return Column(
      children: [
        Image.asset(asset, width: 80, height: 80),
        const SizedBox(height: 4),
        HPBarWidget(current: boss.hp, max: boss.maxHp),
      ],
    );
  }
}
