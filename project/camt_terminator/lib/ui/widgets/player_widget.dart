// lib/widgets/player_widget.dart
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  const PlayerWidget({super.key, required this.player});

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
        ValueListenableBuilder<int?>(
          valueListenable: player.lastDamage,
          builder: (_, damage, __) {
            if (damage == null) return const SizedBox.shrink();
            return Positioned(
              top: 0, // adjust if you want above the sprite
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
