// lib/widgets/hpBar_widget.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HPBarWidget extends StatelessWidget {
  final int current;
  final int max;
  const HPBarWidget({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    double ratio = current / max;
    return Container(
      width: 120,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.red.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center, // <-- center text by default
        children: [
          // Green fill (left-aligned)
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio.clamp(0.0, 1.0), // prevent overflow
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Centered HP text
          Text(
            "$current / $max",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
