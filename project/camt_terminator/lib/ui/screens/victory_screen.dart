// lib/ui/screens/victory_screen.dart
import 'package:flutter/material.dart';
import 'package:camt_terminator/cubit/game_cubit.dart';
import 'package:camt_terminator/ui/screens/combat_screen.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/combat_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Victory!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'You defeated all bosses!',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Go back to menu / home screen
                        GameCubit.I.reset(); // ensure clean state
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Go to Menu'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        GameCubit.I.reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CombatScreen(),
                          ),
                        );
                      },

                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
