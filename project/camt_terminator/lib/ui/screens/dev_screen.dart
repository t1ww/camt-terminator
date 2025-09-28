// project\camt_terminator\lib\ui\screens\dev_screen.dart
import 'package:flutter/material.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = <String, String>{
      '/': 'Menu',
      '/rules': 'Rules',
      '/combat': 'Combat',
      '/gameover': 'Game Over',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: routes.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(entry.key);
              },
              child: Text(entry.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
