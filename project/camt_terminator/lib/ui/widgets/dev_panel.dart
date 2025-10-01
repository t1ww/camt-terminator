// project\camt_terminator\lib\ui\widgets\dev_panel.dart
import 'package:flutter/material.dart';

class DevPanel extends StatelessWidget {
  final VoidCallback onDefeatBoss;

  const DevPanel({super.key, required this.onDefeatBoss});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Developer Tools",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: onDefeatBoss,
            child: const Text("Defeat Boss (Test)"),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
