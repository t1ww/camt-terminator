# CAMT Terminator – Sound Effect Integration (using just_audio)

This document explains how to use the **just_audio** package to add sound effects in Flutter, using an in-game example from **CAMT Terminator**.
You’ll first learn the **basics of using just_audio**, then see a **real example** from the Confirm Boss, and finally complete a **challenge** to practice it.

---

## 1. Basic Usage of just_audio

`just_audio` is a Flutter package for playing short sounds or music tracks.

### 1.1 Installation

Run this command:

```bash
flutter pub add just_audio
```

### 1.2 Adding a Sound Asset

Place your sound file inside your project’s `assets/` folder, for example:

```
assets/sound/example.mp3
```

Then register it in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/sound/example.mp3
```

### 1.3 Playing a Sound

A minimal example:

```dart
import 'package:just_audio/just_audio.dart';

Future<void> playExampleSound() async {
  final player = AudioPlayer();        // 1. Create the player
  await player.setAsset('assets/sound/example.mp3'); // 2. Load the sound
  await player.setVolume(1.0);         // 3. Set volume
  await player.play();                 // 4. Play once
  player.dispose();                    // 5. Dispose when done
}
```

**Key idea:**
Every sound effect needs a player → load → play → dispose.
This pattern is used directly inside gameplay code.

---

## 2. Example – Confirm Boss Snap Sound

This example plays a sound when the **Confirm Boss** uses its shuffle ability inside `lib/cubit/card_cubit.dart`.

```dart
// Confirm boss ability: Shuffle player cards
if (boss is ConfirmBoss) {
  if (boss.hp.value > (boss.maxHp / 2)) {
    // Swap a single random pair
    if (selectedCards.length >= 2) {
      final rng = Random();
      final i = rng.nextInt(selectedCards.length);
      int j;
      do {
        j = rng.nextInt(selectedCards.length);
      } while (j == i);
      final temp = selectedCards[i];
      selectedCards[i] = selectedCards[j];
      selectedCards[j] = temp;
    }
  } else {
    // Shuffle the whole selection
    selectedCards.shuffle();
  }

  // --- Play the snap sound effect ---
  final snapSoundPlayer = AudioPlayer();
  try {
    await snapSoundPlayer.setAsset('assets/sound/Con_snap_v2.mp3');
    await snapSoundPlayer.setVolume(1.0);
    await snapSoundPlayer.play();
  } catch (e) {
    print('Error playing SFX: $e');
  } finally {
    snapSoundPlayer.dispose(); // always free memory
  }
  // --- End of sound effect ---

  await Future.delayed(const Duration(milliseconds: 200));
  selectedCardsNotifier.value = selectedCards;
  await Future.delayed(const Duration(seconds: 1));
}
```

### Explanation

1. **Create** a new `AudioPlayer` instance
2. **Load** the MP3 file from assets
3. **Set volume** (1.0 = 100%)
4. **Play** the sound once
5. **Dispose** to release memory

---

## 3. Challenge – Add a Draw Card Sound

Try applying the same logic to when player draw a card.

**Goal:**
Find and insert a new "draw" sound effect.
Play a short "draw" sound whenever the player draws new cards.

---

### Answer if you couldn't figure it out.
📑[answer.md](md/answer.md)