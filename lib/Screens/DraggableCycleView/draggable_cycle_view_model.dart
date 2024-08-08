import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class DraggableCycleViewModel extends GetxController {
  var count = 0.obs;
  var offsetY = 0.0.obs;
  var beadOffsets = List<double>.filled(13, 0.0).obs;

  var isVibration = true.obs;
  var isSoundEffect = true.obs;

  void increment() {
    playSoundAndVibrate();
    count.value++;
  }

  void playSoundAndVibrate() {
    playSound(isSoundEffect.value);
    _vibrate([0, 50, 0, 0], isVibration.value);
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
    switch (count.value) {
      case 33:
        playSound(isSoundEffect.value);
        _vibrate([0, 300, 0, 0], isVibration.value);
        break;
      case 66:
        playSound(isSoundEffect.value);
        _vibrate([0, 300, 100, 300], isVibration.value);
        break;
      case 99:
        playSound(isSoundEffect.value);
        _vibrate([0, 300, 100, 300, 100, 300], isVibration.value);
        break;
      default:
    }
  }

  void resetPosition() {
    offsetY.value = 0.0;
    beadOffsets.value = List<double>.filled(13, 0.0);
  }

  void resetCounter() {
    count.value = 1;
    resetPosition();
  }

  void _vibrate(List<int> pattern, bool isVibrate) {
    isVibrate ? Vibration.vibrate(pattern: pattern) : null;
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
