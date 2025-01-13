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

  bool shortVibrationPending = false;

  void increment() {
    if (isVibrating.value) {
      shortVibrationPending = true;
    } else {
      playSoundAndVibrate();
    }

    lastCount.value++;
    updateText();
    onCountChanged(lastCount.value);
  }

  void playSoundAndVibrate() {
    // Eğer uzun titreşim yoksa direk titreşim yap
    // Uzun titreşim varsa zaten increment içerisinde kontrol ettik.
    if (!isVibrating.value) {
      playSound(isSoundEffect.value);
      _vibrate([0, 50], isVibration.value);
    } else {
      // Eğer uzun titreşim devam ederken bu metot çağrılırsa,
      // kısa titreşim daha sonra yapılmak üzere shortVibrationPending true yapılır.
      shortVibrationPending = true;
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
        longVibrate([0, 300], isVibration.value);
        break;
      case 66:
        playSound(isSoundEffect.value);
        longVibrate([0, 300, 100, 300], isVibration.value);
        break;
      case 99:
        playSound(isSoundEffect.value);
        longVibrate([0, 300, 100, 300, 100, 300], isVibration.value);
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
  void longVibrate(List<int> pattern, bool isVibrate) async {
    if (isVibrate) {
      isVibrating.value = true; // Titreşim kilidini aktif et
      await Vibration.vibrate(pattern: pattern);
      isVibrating.value = false; // Titreşim kilidini kapat

      if (shortVibrationPending) {
        playSound(isSoundEffect.value);
        _vibrate([0, 50], isVibration.value);
        shortVibrationPending = false;
      }
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

  void onCountChanged(int count) {}
}
