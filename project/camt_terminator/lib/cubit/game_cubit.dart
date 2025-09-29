// lib/cubit/game_cubit.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../ui/screens/gameover_screen.dart'; // <-- we’ll use this page

class GameCubit {
  GameCubit._();
  static final GameCubit I = GameCubit._();

  OverlayState? _overlay; // local overlay from CombatScreen
  BuildContext? _hostContext; // BuildContext of CombatScreen
  OverlayEntry? _bossOverlay;
  OverlayEntry? _endBtnOverlay;
  Timer? _timer;

  GamePhase _phase = GamePhase.idle;
  GamePhase get phase => _phase;

  /// Start the loop with the *local* overlay of CombatScreen and its context.
  void onEnterCombatWithOverlay(
    OverlayState overlay,
    BuildContext hostContext,
  ) {
    _overlay = overlay;
    _hostContext = hostContext;
    _clearAll();
    _phase = GamePhase.bossSummoned;

    _insertBossOverlay();
    _insertEndButtonOverlay();
  }

  /// Clean everything (called on back/dispose, or restart).
  void teardownIfAny() {
    _clearAll();
    _overlay = null;
    _hostContext = null;
    _phase = GamePhase.idle;
  }

  /* ---------------- internal helpers ---------------- */

  void _clearAll() {
    _timer?.cancel();
    _timer = null;

    _bossOverlay?.remove();
    _bossOverlay = null;

    _endBtnOverlay?.remove();
    _endBtnOverlay = null;
  }

  void _insertBossOverlay() {
    final overlay = _overlay;
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: IgnorePointer(
          ignoring: true,
          child: Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xCC000000),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Center(
                child: Text(
                  'BOSS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _bossOverlay = entry;
    overlay.insert(entry);
  }

  void _insertEndButtonOverlay() {
    final overlay = _overlay;
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 24,
        left: 0,
        right: 0,
        child: IgnorePointer(
          ignoring: false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: ElevatedButton(
                onPressed: _goToGameOver, // <-- navigate to game over
                child: const Text('End (test)'),
              ),
            ),
          ),
        ),
      ),
    );

    _endBtnOverlay = entry;
    overlay.insert(entry);
  }

  void _goToGameOver() {
    _phase = GamePhase.ended;

    _clearAll();

    final ctx = _hostContext;
    if (ctx == null) return;

    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const GameoverScreen(), 
      ),
    );
  }
}

enum GamePhase { idle, bossSummoned, ended }
