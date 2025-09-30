// lib/cubit/game_cubit.dart
import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/boss_model.dart';
import '../data/boss_data.dart';
import '../ui/screens/gameover_screen.dart';

class GameCubit {
  GameCubit._();
  static final GameCubit I = GameCubit._();

  // Game state
  GamePhase _phase = GamePhase.idle;
  GamePhase get phase => _phase;

  // Player & Boss instances
  late Player player;
  late Boss boss;

  // Boss tracking
  final List<Boss> _bossPool = [...allBosses]; // copy
  int _bossKills = 0;
  static const int maxBossKills = 4;

  /// Start combat with a new player and first boss
  void startCombat({Player? initPlayer}) {
    _phase = GamePhase.bossSummoned;
    _bossKills = 0;

    // Shuffle boss pool
    _bossPool.shuffle();

    // Initialize player
    player = initPlayer ?? Player();

    // Spawn first boss
    boss = _popNextBoss();
  }

  /// Called when current boss is defeated
  /// Returns true if game continues, false if game ends
  bool onBossDefeated(BuildContext context) {
    _bossKills++;

    if (_bossKills >= maxBossKills || _bossPool.isEmpty) {
      _phase = GamePhase.ended;

      // Navigate to GameOver screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GameoverScreen()),
      );
      return false;
    }

    // Spawn next boss
    boss = _popNextBoss();
    _phase = GamePhase.bossSummoned;
    return true;
  }

  /// Get next boss from shuffled pool
  Boss _popNextBoss() {
    return _bossPool.removeLast();
  }

  /// Reset everything to initial state
  void reset() {
    _phase = GamePhase.idle;
    _bossKills = 0;
    _bossPool
      ..clear()
      ..addAll(allBosses);
    _bossPool.shuffle();
    player = Player();
  }
}

enum GamePhase { idle, bossSummoned, ended }
