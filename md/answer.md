# Challenge Answer: Play Sound on Draw Card

This demonstrates how to play a sound whenever a card is drawn from the deck in **CAMT Terminator**, using the existing `_music` player pattern in `GameCubit` (from `lib/cubit/game_cubit.dart`).

---

## 1. Add a Draw Sound Asset

Place a draw card sound in your assets folder:

```
assets/song/draw_card.mp3
````

Then register it in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/song/draw_card.mp3
````

---

## 2. Add a Helper Method in GameCubit

You can reuse the same `_music` player or create a small one-off player.
For simplicity, we’ll add a helper in `GameCubit`:

```dart
extension GameCubitDrawSound on GameCubit {
  Future<void> playDrawSound() async {
    await _ensureMusic(); // make sure the player is ready
    await _music.setAsset('assets/song/draw_card.mp3', preload: true);
    _music.setLoopMode(LoopMode.off);
    await _music.play();
  }
}
```

> Note: `_ensureMusic()` already exists in `GameCubit` to configure audio sessions and volume.

---

## 3. Trigger Sound in DeckWidget

Update your `DeckWidget`’s `deckDraw()` method to call the sound:

```dart
void deckDraw() {
  onTap?.call(); // existing callback for drawing cards

  // Play draw card sound
  GameCubit.I.playDrawSound();
}
```

Now, whenever the player taps the deck:

* `onTap` still draws the card(s)
* `playDrawSound()` plays the sound

---

## 4. Result

* Tap the deck → a card is drawn → the draw card sound plays
* You can extend this pattern to other actions (attack, defense, consumables) by creating similar helper methods in `GameCubit`.

---

## Notes

* Using the **singleton GameCubit.I** allows easy access to the audio player anywhere in the UI
* `_music.setLoopMode(LoopMode.off)` ensures one-shot sounds don’t loop accidentally
* Preload the asset to avoid delays during gameplay