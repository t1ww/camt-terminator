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

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Image.asset(asset, width: 96, height: 96),
            const SizedBox(height: 4),
            // Hp bar
            ValueListenableBuilder<int>(
              valueListenable: boss.hp,
              builder: (_, currentHp, __) {
                return HPBarWidget(current: currentHp, max: boss.maxHp);
              },
            ),
          ],
        ),

        // Floating damage overlay
        ValueListenableBuilder<int?>(
          valueListenable: boss.lastDamage,
          builder: (_, damage, __) {
            if (damage == null) return const SizedBox.shrink();
            return Positioned(
              top: 0, // adjust so it shows above boss sprite
              child: Text(
                "-$damage",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      offset: Offset(1, 1),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
