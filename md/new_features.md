# CAMT Terminator - New Features Documentation

This document explains the **new features** added to CAMT Terminator, including **animated card attack effects** using Rive and **sound effects** using just_audio, and how to integrate them into the project. <br>
To Demonstrate the new Flutter libraries not covered in class

---

## 1. Animated Card Attack Effects (Rive)

**Purpose:**  
- Make card attacks and defenses visually engaging  

**Library:** [rive](https://pub.dev/packages/rive)

**Setup:**
1. Install the package:
```bash
flutter pub add rive
````

2. Add Rive animation files to `assets/animations/`, e.g., `attack.riv`, `defense.riv`
3. Register assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/animations/attack.riv
    - assets/animations/defense.riv
```

**Usage:**

* Create a widget to play animations:

```dart
import 'package:rive/rive.dart';

class CardAnimationWidget extends StatelessWidget {
  final String animationFile;
  final String animationName;

  const CardAnimationWidget({
    required this.animationFile,
    required this.animationName,
  });

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      animationFile,
      animations: [animationName],
      fit: BoxFit.contain,
    );
  }
}
```

* Trigger animations on card action:

  * When player/boss plays an AttackCard → show `attack.riv`
  * When a DefenseCard is used → show `defense.riv`

---

## 2. Sound Effects (just_audio)

**Purpose:**

* Add audio feedback for card actions
* Increase player immersion

**Library:** [just_audio](https://pub.dev/packages/just_audio)

**Setup:**

1. Install the package:

```bash
flutter pub add just_audio
```

2. Place audio files in `assets/sounds/`, e.g., `attack.mp3`, `defense.mp3`, `heal.mp3`
3. Register assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/sounds/attack.mp3
    - assets/sounds/defense.mp3
    - assets/sounds/heal.mp3
```

**Usage:**

```dart
import 'package:just_audio/just_audio.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String assetPath) async {
    await _player.setAsset(assetPath);
    _player.play();
  }
}
```

* Trigger sounds when card actions occur:

```dart
if (card is AttackCard) {
  audioManager.play('assets/sounds/attack.mp3');
} else if (card is DefenseCard) {
  audioManager.play('assets/sounds/defense.mp3');
} else if (card is ConsumableCard && card.type == 'Heal') {
  audioManager.play('assets/sounds/heal.mp3');
}
```

---

## 3. Integration with Project

### **State Management (Cubit/Bloc):**

  * Listens to player card selections and updates game state.
  * Triggers side effects such as:

    1. Playing Rive animations when cards are used
    2. Playing sound effects using `just_audio`

### **UI Layer:**

  * `CardWidget` can wrap the Rive animation and call `AudioManager.play()` when the card is played.
  * Example usage in `CardWidget`:

  ```dart
  GestureDetector(
    onTap: () {
      cardCubit.playCard(card);
      cardAnimationWidget.playAnimation(card.type);
      audioManager.play(card.audioAsset);
    },
    child: CardWidgetVisual(card: card),
  );
  ```

### **Practical Flow:**

  1. Player chooses cards → Cubit updates state with selected cards
  2. On combat turn start, trigger:

     * Rive animation for each card (Attack/Defense)
     * Corresponding sound effect
  3. CombatResolver calculates damage, defense, and consumable effects → updates player and boss HP
  4. UI layer listens to Cubit state updates and refreshes card hands, HP bars, and any feedback animations

---

## Notes / Tips

* Keep **animations short** (0.5–1 sec) to avoid delaying gameplay
* Use **AudioManager singleton** to reuse one audio player for multiple sounds
* Record a short demo showing animation + sound combo for your presentation

---

## References

* [Rive Flutter Package](https://pub.dev/packages/rive)
* [just_audio Flutter Package](https://pub.dev/packages/just_audio)