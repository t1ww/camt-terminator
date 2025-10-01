// lib/widgets/player_widget.dart
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';
import 'hpBar_widget.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  const PlayerWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(  
      children: [
        Image.asset('assets/images/player.png', width: 96, height: 96),
        const SizedBox(height: 4),
        HPBarWidget(current: player.hp.value, max: player.maxHp.toInt()),
      ],
    );
  }
}
