// lib/widgets/player_widget.dart
import 'dart:math';

import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  const PlayerWidget({super.key, required this.player});

  // Helper: random horizontal offset from -16 to +16
  double randomOffset(double maxOffset) {
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
            // HP bar (reactive)
            ValueListenableBuilder<int>(
              valueListenable: player.hp,
              builder: (_, currentHp, __) {
                return HPBarWidget(current: currentHp, max: player.maxHp);
              },
            ),
          ],
        ),

        // Floating overlays: damage (red) and heal (green)
        // Nest two ValueListenableBuilders so both lists update independently.
        ValueListenableBuilder<List<int>>(
          valueListenable: player.damageEvents,
          builder: (_, damages, __) {
            return ValueListenableBuilder<List<int>>(
              valueListenable: player.healEvents,
              builder: (_, heals, __) {
                // Nothing to show
                if (damages.isEmpty && heals.isEmpty)
                  return const SizedBox.shrink();

                // Container sized to cover the player sprite
                return SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Damage texts (stacked and slightly staggered)
                      for (int i = 0; i < damages.length; i++)
                        Transform.translate(
                          offset: Offset(randomOffset(20), -18.0 * i),
                          child: Text(
                            "-${damages[i]}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Heal texts (stacked and slightly staggered below)
                      for (int i = 0; i < heals.length; i++)
                        Transform.translate(
                          offset: Offset(randomOffset(20), 18.0 * i),
                          child: Text(
                            "+${heals[i]}",
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
