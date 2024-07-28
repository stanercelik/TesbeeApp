import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class BeadsViewModel extends GetxController {
  var count = 0.obs;
  var offsetY = 0.0.obs;
  var beadOffsets = List<double>.filled(13, 0.0).obs;

  var subanallah = "Subhanallah".obs;
  var elhamdulillah = "Elhamdulillah".obs;
  var allahuEkber = "Allahu ekber".obs;

  var currentText = "Subhanallah".obs;

  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  var isVibration = true.obs;
  var isSoundEffect = true.obs;

  void increment() {
    playSound(isSoundEffect.value);
    _vibrate([0, 50, 0, 0], isVibration.value);

    if (count >= 99) {
      resetCounter();
    } else {
      count++;
      updateText();
    }
  }

  void updatePosition(double delta) {
    offsetY.value += delta;

    for (int i = 0; i < beadOffsets.length; i++) {
      beadOffsets[i] += delta / 2.5;
    }
  }

  void updateText() {
    switch (count.value) {
      case 33:
        playSound(isSoundEffect.value);
        _vibrate([0, 300, 0, 0], isVibration.value);
      case 66:
        playSound(isSoundEffect.value);
        _vibrate([0, 300, 100, 300], isVibration.value);
      case 99:
        playSound(isSoundEffect.value);
        _vibrate([0, 300, 100, 300, 100, 300], isVibration.value);
        break;
      default:
    }
    if (count < 33) {
      currentText.value = subanallah.value;
    } else if (count < 66) {
      currentText.value = elhamdulillah.value;
    } else if (count < 99) {
      currentText.value = allahuEkber.value;
    }
  }

  void resetPosition() {
    offsetY.value = 0.0;
    beadOffsets.value = List<double>.filled(13, 0.0);
  }

  void resetCounter() {
    count.value = 1;
    currentText.value = subanallah.value;
    resetPosition();
  }

  void _vibrate(List<int> pattern, bool isVibrate) {
    isVibrate ? Vibration.vibrate(pattern: pattern) : null;
  }

  void changeBeadColor(Color color) {
    beadColor.value = color;
  }

  void changeStringColor(Color color) {
    stringColor.value = color;
  }

  void changeBackgroundColor(Color color) {
    backgroundColor.value = color;
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
