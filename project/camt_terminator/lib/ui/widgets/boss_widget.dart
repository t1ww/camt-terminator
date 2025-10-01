// lib/widgets/boss_widget.dart
import 'dart:math';
import 'package:camt_terminator/models/boss_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class BossWidget extends StatelessWidget {
  final Boss boss;
  const BossWidget({super.key, required this.boss});

  double randomOffset() {
    final maxOffset = 32.0;
    final rand = Random();
    return (rand.nextDouble() * 2 - 1) * maxOffset;
  }

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
            ValueListenableBuilder<int>(
              valueListenable: boss.hp,
              builder: (_, currentHp, __) {
                return HPBarWidget(current: currentHp, max: boss.maxHp);
              },
            ),
          ],
        ),

        // Floating damage overlay
        ValueListenableBuilder<List<int>>(
          valueListenable: boss.damageEvents,
          builder: (_, damages, __) {
            if (damages.isEmpty) return const SizedBox.shrink();

            return SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < damages.length; i++)
                    Transform.translate(
                      offset: Offset(randomOffset(), -20.0 * i),
                      child: Text(
                        "-${damages[i]}",
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
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
