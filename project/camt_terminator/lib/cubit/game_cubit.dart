// lib/cubit/game_cubit.dart
import 'package:camt_terminator/main.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/player_model.dart';
import '../models/boss_model.dart';
import '../data/boss_data.dart';
import '../ui/screens/victory_screen.dart';

class GameCubit {
  // Singleton pattern
  GameCubit._();
  static final GameCubit I = GameCubit._();

  // Observer pattern
  final ValueNotifier<Player?> playerNotifier = ValueNotifier(null);
  final ValueNotifier<Boss?> bossNotifier = ValueNotifier(null);

  // Player an boss with notifier for value change
  Player get player => playerNotifier.value!;
  Boss get boss => bossNotifier.value!;

  set player(Player p) => playerNotifier.value = p;
  set boss(Boss b) => bossNotifier.value = b;

  // Bosskill for round counting
  final ValueNotifier<int> bossKillsNotifier = ValueNotifier(0);

  // Game state
  GamePhase _phase = GamePhase.idle;
  GamePhase get phase => _phase;

  // Boss tracking
  final List<Boss> _bossPool = [...allBosses]; // copy
  static const int maxBossKills = 4;

  // ==== Volume state ====
  double _userVolume = 0.35; // 35% base default
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
    bossKillsNotifier.value = 0;

    // Shuffle boss pool
    _bossPool.shuffle();

    // Initialize player
    player = initPlayer ?? Player();

    // Pick first boss synchronously
    boss = _popNextBoss();

    await _ensureMusic();

    final path = _trackByBossId[boss.id];
    if (path != null) {
      _music.setLoopMode(LoopMode.one);
      _music.setVolume(_muted ? 0.0 : _volumeForBoss(boss.id));

      _music.setAsset(path);
      _music.play();
    }

    _ensureMusic();
  }

  /// Called when current boss is defeated
  /// Returns true if game continues, false if game ends
  bool onBossDefeated() {
    // ✅ Increment AFTER finishing current boss
    bossKillsNotifier.value++;

    // ✅ Win condition
    if (bossKillsNotifier.value >= maxBossKills || _bossPool.isEmpty) {
      _phase = GamePhase.ended;
      _stopMusic();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const VictoryScreen()),
        );
      });
      return false;
    }

    // spawn next boss and music
    boss = _popNextBoss();
    _phase = GamePhase.bossSummoned;
    _playTrackForBoss(boss);

    return true;
  }

  // When lose
  void onPlayerDefeated() {
    _phase = GamePhase.ended;
    _stopMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushReplacementNamed('/gameover');
    });
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
      _muted ? 0.0 : _volumeForBoss(b.id),
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
    bossKillsNotifier.value = 0;

    _bossPool
      ..clear()
      ..addAll(allBosses);
    _bossPool.shuffle();
    player = Player();

    _musicReady = false; // keep this so music re-inits on next start
  }

  // Helper: choose special volume if set
  double _volumeForBoss(String bossId) {
    switch (bossId) {
      case 'boss_party':
        return 0.40;
      case 'boss_plub':
        return 0.33;
      default:
        return _userVolume;
    }
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
