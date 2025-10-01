// lib/cubit/game_cubit.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/player_model.dart';
import '../models/boss_model.dart';
import '../data/boss_data.dart';
import '../ui/screens/gameover_screen.dart';

class GameCubit {
  // Singleton pattern
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

  // Get round, count from bossKill
  int getRound() {
    return _bossKills + 1;
  }

  // ==== Volume state ====
  double _userVolume = 0.35; // 50% at start
  bool _muted = false;

  double get volume => _userVolume;
  bool get muted => _muted;

  void setVolume(double v) {
    _userVolume = v.clamp(0.0, 1.0);
    _music.setVolume(_muted ? 0.0 : _userVolume);
  }

  void toggleMute() {
    _muted = !_muted;
    _music.setVolume(_muted ? 0.0 : _userVolume);
  }

  /// Start combat with a new player and first boss
  Future<void> startCombat({Player? initPlayer}) async {
    _phase = GamePhase.bossSummoned;
    _bossKills = 0;

    // Shuffle boss pool
    _bossPool.shuffle();

    // Initialize player
    player = initPlayer ?? Player();

    // Pick first boss synchronously
    boss = _popNextBoss();

    final path = _trackByBossId[boss.id];
    if (path != null) {
      _music.setLoopMode(LoopMode.one);
      _music.setVolume(_muted ? 0.0 : _userVolume);

      _music.setAsset(path);
      _music.play();
    }

    _ensureMusic();
  }

  /// Called when current boss is defeated
  /// Returns true if game continues, false if game ends
  bool onBossDefeated(BuildContext context) {
    _bossKills++;

    if (_bossKills >= maxBossKills || _bossPool.isEmpty) {
      _phase = GamePhase.ended;

      // stop music on game end
      _stopMusic();

      // Navigate to GameOver screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GameoverScreen()),
      );
      return false;
    }

    // Spawn next boss
    boss = _popNextBoss();
    _phase = GamePhase.bossSummoned;

    // swap to the new boss track
    _playTrackForBoss(boss); // fire-and-forget

    return true;
  }

  /// Get next boss from shuffled pool
  Boss _popNextBoss() {
    return _bossPool.removeLast();
  }

  Future<void> _ensureMusic() async {
    if (_musicReady) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await _music.setLoopMode(LoopMode.one);
    await _music.setVolume(_muted ? 0.0 : _userVolume);
    _musicReady = true;
  }

  Future<void> _fadeTo(double target, Duration d) async {
    final steps = 12;
    final start = _music.volume;
    final dt = d.inMilliseconds ~/ steps;
    for (var i = 1; i <= steps; i++) {
      final v = start + (target - start) * (i / steps);
      _music.setVolume(v.clamp(0.0, 1.0));
      await Future.delayed(Duration(milliseconds: dt > 0 ? dt : 1));
    }
  }

  Future<void> _playTrackForBoss(Boss b) async {
    await _ensureMusic();
    final path = _trackByBossId[b.id];
    if (path == null) return; // no track mapped
    await _fadeTo(0.0, const Duration(milliseconds: 400));
    await _music.setAsset(path, preload: true);
    await _music.play();
    await _fadeTo(
      _muted ? 0.0 : _userVolume,
      const Duration(milliseconds: 400),
    );
  }

  Future<void> _stopMusic() async {
    if (!_musicReady) return;
    await _fadeTo(0.0, const Duration(milliseconds: 250));
    await _music.stop();
  }

  /// Reset everything to initial state
  void reset() {
    _stopMusic();
    _phase = GamePhase.idle;
    _bossKills = 0;
    _bossPool
      ..clear()
      ..addAll(allBosses);
    _bossPool.shuffle();
    player = Player();
  }

  final AudioPlayer _music = AudioPlayer();
  bool _musicReady = false;

  static const Map<String, String> _trackByBossId = {
    'boss_plub': 'assets/song/Plub_theme.mp3',
    'boss_confirm': 'assets/song/Con_theme.mp3',
    'boss_tew': 'assets/song/Tew_theme.mp3',
    'boss_party': 'assets/song/Party_theme.mp3',
  };
}

enum GamePhase { idle, bossSummoned, ended }
