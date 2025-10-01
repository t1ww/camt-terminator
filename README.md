# CAMT Terminator - New Features Documentation

This document explains the **sound feature** added to CAMT Terminator using just_audio, and how to integrate it into the project.  
It demonstrates a real example from the game: **playing boss music**.

---

## 1. Sound Effects (just_audio)

**Purpose:**

* Play background music for bosses
* Increase player immersion

**Library:** [just_audio](https://pub.dev/packages/just_audio)

**Setup:**

1. Install the package:

```bash
flutter pub add just_audio
````

2. Place audio files in `assets/song/`, e.g.:

```
assets/song/Plub_theme.mp3
assets/song/Con_theme.mp3
assets/song/Tew_theme.mp3
assets/song/Party_theme.mp3
```

3. Register assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/song/Plub_theme.mp3
    - assets/song/Con_theme.mp3
    - assets/song/Tew_theme.mp3
    - assets/song/Party_theme.mp3
```

---

## 2. Usage Example from Project

In `lib/cubit/game_cubit.dart`, **boss music** is handled like this:

```dart
final AudioPlayer _music = AudioPlayer();

Future<void> _playTrackForBoss(Boss b) async {
  final path = _trackByBossId[b.id];
  if (path == null) return; // no track mapped

  // fade out previous track
  await _fadeTo(0.0, const Duration(milliseconds: 400));

  // load and play new boss track
  await _music.setAsset(path, preload: true);
  _music.setLoopMode(LoopMode.one);
  await _music.play();

  // fade in to appropriate volume
  await _fadeTo(_volumeForBoss(b.id), const Duration(milliseconds: 400));
}
```

*Boss tracks are mapped in `_trackByBossId`:*

```dart
static const Map<String, String> _trackByBossId = {
  'boss_plub': 'assets/song/Plub_theme.mp3',
  'boss_confirm': 'assets/song/Con_theme.mp3',
  'boss_tew': 'assets/song/Tew_theme.mp3',
  'boss_party': 'assets/song/Party_theme.mp3',
};
```

*Volume is managed per boss with `_volumeForBoss()`.*

---

## 3. Challenge

As an extra exercise, try **adding a draw card sound** using the same `_music` player pattern:

* Place a `draw.mp3` in `assets/sounds/`
* Map it in a helper like `_trackByAction`
* Play it whenever a card is drawn, optionally with a small fade-in/out

This encourages understanding **how to extend just_audio for multiple game events**.

---

## Notes / Tips

* `_music` is reused for all boss tracks to save resources
* `_fadeTo()` helps smooth transitions between tracks
* You can adapt the same pattern to other game sounds (e.g., card draw, attack, heal)