// lib/widgets/boss_widget.dart
import 'package:camt_terminator/models/boss_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class BossWidget extends StatelessWidget {
  final Boss boss;
  const BossWidget({super.key, required this.boss});

  @override
  Widget build(BuildContext context) {
    final assetMap = {
      'boss_plub': 'assets/images/boss1.png',
      'boss_confirm': 'assets/images/boss2.png',
      'boss_tew': 'assets/images/boss3.png',
      'boss_party': 'assets/images/boss4.png',
    };
    final asset = assetMap[boss.id] ?? 'assets/images/boss1.png';

    return Column(
      children: [
        Image.asset(asset, width: 96, height: 96),
        const SizedBox(height: 4),
        ValueListenableBuilder<int>(
          valueListenable: boss.hp,
          builder: (_, currentHp, __) {
            return HPBarWidget(current: currentHp, max: boss.maxHp);
          },
        ),
      ],
    );
  }
}