// lib/ui/screens/gameover_screen.dart
import 'package:flutter/material.dart';
import 'combat_screen.dart';
import 'menu_screen.dart';

class GameoverScreen extends StatelessWidget {
  const GameoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // keep your theme; adjust as you like
          gradient: LinearGradient(
            colors: [Color(0xFF131A24), Color(0xFF0B0F14)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GAME OVER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Manual end via button (loop OK)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Restart the fight
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const CombatScreen(),
                            ),
                          );
                        },
                        child: const Text('Restart'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          // Back to main menu and clear history
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const MenuScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Back to Menu'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
