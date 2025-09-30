// lib/cubit/game_cubit.dart
import 'dart:async';
import 'dart:math';
import 'package:camt_terminator/data/boss_data.dart';
import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/boss_model.dart';
import '../ui/screens/gameover_screen.dart';

class GameCubit {
  GameCubit._();
  static final GameCubit I = GameCubit._();

  OverlayState? _overlay; // Overlay from CombatScreen
  BuildContext? _hostContext; // BuildContext of CombatScreen
  OverlayEntry? _bossOverlay;
  OverlayEntry? _endBtnOverlay;
  Timer? _timer;

  GamePhase _phase = GamePhase.idle;
  GamePhase get phase => _phase;

  // Player & Boss instances
  late Player player;
  late Boss boss;

  /// Start combat with overlays and initialize player & boss
  void onEnterCombatWithOverlay(
    OverlayState overlay,
    BuildContext hostContext, {
    required Player initPlayer,
    required Boss initBoss,
  }) {
    _overlay = overlay;
    _hostContext = hostContext;
    _clearAll();

    player = initPlayer;
    boss = initBoss;

    _phase = GamePhase.bossSummoned;

    _insertBossOverlay();
    _insertEndButtonOverlay();
  }

  /// Clean everything (called on back/dispose, or restart)
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
              child: Center(
                child: Text(
                  boss.name,
                  style: const TextStyle(
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
                onPressed: _goToGameOver,
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
      MaterialPageRoute(builder: (_) => const GameoverScreen()),
    );
  }

  /// Pick a random boss from available ones
  Boss getRandomBoss() {
    final rnd = Random();
    return allBosses[rnd.nextInt(allBosses.length)];
  }

  /// Initialize player if not yet created
  Player getPlayerInstance() {
    player = Player(); // default stats
    return player;
  }
}

enum GamePhase { idle, bossSummoned, ended }
