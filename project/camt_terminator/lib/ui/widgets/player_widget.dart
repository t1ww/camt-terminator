// lib/widgets/player_widget.dart
import 'dart:math';

import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  const PlayerWidget({super.key, required this.player});

  // Helper: random horizontal offset from -16 to +16
  double randomOffset() {
    final maxOffset = 32.0;
    final rand = Random();
    return (rand.nextDouble() * 2 - 1) * maxOffset;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Image.asset('assets/images/player.png', width: 96, height: 96),
            const SizedBox(height: 4),
            // Hp bar
            ValueListenableBuilder<int>(
              valueListenable: player.hp,
              builder: (_, currentHp, __) {
                return HPBarWidget(current: currentHp, max: player.maxHp);
              },
            ),
          ],
        ),

        // Floating damage overlay
        ValueListenableBuilder<List<int>>(
          valueListenable: player.damageEvents,
          builder: (_, damages, __) {
            if (damages.isEmpty) return const SizedBox.shrink();

            return SizedBox(
              width: 100, // enough to cover player image
              height: 100, // enough height to float
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < damages.length; i++)
                    Transform.translate(
                      offset: Offset(randomOffset(), randomOffset() * i),
                      child: Text(
                        "-${damages[i]}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
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
