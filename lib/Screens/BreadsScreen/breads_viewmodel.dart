import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class BreadsViewModel extends GetxController {
  var count = 0.obs;
  var offsetY = 0.0.obs;
  var beadOffsets = List<double>.filled(13, 0.0).obs;

  var subanallah = "Subhanallah".obs;
  var elhamdulillah = "Elhamdulillah".obs;
  var allahuEkber = "Allahu ekber".obs;

  var currentText = "Subhanallah".obs;

  void increment() {
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
    if (count.value == 33) {
      _vibrate([0, 300, 0, 0]);
    }
    if (count.value == 66) {
      _vibrate([0, 250, 100, 250]);
    }
    if (count.value == 99) {
      _vibrate([0, 250, 100, 250, 100, 250]);
    }
    if (count < 33) {
      currentText.value = subanallah.value;
    } else if (count < 66) {
      currentText.value = elhamdulillah.value;
    } else {
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

  void _vibrate(List<int> pattern) {
    Vibration.vibrate(pattern: pattern);
  }
}
