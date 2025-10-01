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
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: ratio,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
