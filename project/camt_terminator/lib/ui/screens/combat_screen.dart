// lib/ui/screens/combat_screen.dart
import 'package:flutter/material.dart';
import 'package:camt_terminator/cubit/game_cubit.dart';

class CombatScreen extends StatefulWidget {
  const CombatScreen({super.key});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  final _overlayKey = GlobalKey<OverlayState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ov = _overlayKey.currentState;
      if (ov != null) {
        // pass overlay + this screen context
        GameCubit.I.onEnterCombatWithOverlay(ov, context);
      }
    });
  }

  @override
  void dispose() {
    GameCubit.I.teardownIfAny(); // removes boss/button instantly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Overlay(
        key: _overlayKey,
        initialEntries: [
          OverlayEntry(
            builder: (_) => Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/combat_background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
