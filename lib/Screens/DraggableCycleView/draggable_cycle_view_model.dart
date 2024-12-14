import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class DraggableCycleViewModel extends GetxController {
  var lastCount = 0.obs;
  var offsetY = 0.0.obs;
  var beadOffsets = List<double>.filled(13, 0.0).obs;

  var isVibration = true.obs;
  var isSoundEffect = true.obs;

  // Yeni eklenen değişken: Titreşim kilidi
  var isVibrating = false.obs;

  void increment() {
    playSoundAndVibrate();
    lastCount.value++;
    updateText();
  }

  void playSoundAndVibrate() {
    // Eğer uzun titreşim devam ediyorsa, kısa titreşimi tetikleme
    if (!isVibrating.value) {
      playSound(isSoundEffect.value);
      _vibrate([0, 50], isVibration.value);
    }
  }

  void updatePosition(double delta) {
    offsetY.value += delta;

    for (int i = 0; i < beadOffsets.length; i++) {
      beadOffsets[i] += delta / 2.5;
    }
  }

  void updateText() {
    soundAndVibrateExactValue();
  }

  void soundAndVibrateExactValue() {
    switch (lastCount.value) {
      case 33:
        playSound(isSoundEffect.value);
        _longVibrate([0, 300], isVibration.value);
        break;
      case 66:
        playSound(isSoundEffect.value);
        _longVibrate([0, 300, 100, 300], isVibration.value);
        break;
      case 99:
        playSound(isSoundEffect.value);
        _longVibrate([0, 300, 100, 300, 100, 300], isVibration.value);
        break;
      default:
    }
  }

  void resetPosition() {
    offsetY.value = 0.0;
    beadOffsets.value = List<double>.filled(13, 0.0);
  }

  void resetCounter() {
    lastCount.value = 1;
    resetPosition();
  }

  void _vibrate(List<int> pattern, bool isVibrate) {
    if (isVibrate) {
      Vibration.vibrate(pattern: pattern);
    }
  }

  // Uzun titreşimleri yöneten asenkron fonksiyon
  void _longVibrate(List<int> pattern, bool isVibrate) async {
    if (isVibrate) {
      isVibrating.value = true; // Titreşim kilidini aktif et
      await Vibration.vibrate(pattern: pattern);
      isVibrating.value = false; // Titreşim kilidini kapat
    }
  }

  void playSound(bool soundEffect) async {
    if (soundEffect) {
      final player = AudioPlayer();
      await player.play(
        AssetSource('sound/wooden_click.mp3'),
      );
    }
  }
}
