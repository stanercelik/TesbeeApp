import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Constants/string_constants.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';
import 'package:tesbih_app/Screens/DraggableCycleView/draggable_cycle_view_model.dart';

class BeadsViewModel extends DraggableCycleViewModel {
  var currentText = StringConstants.subhanallahString.obs;

  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  @override
  void increment() {
    playSoundAndVibrate();
    if (count >= 99) {
      resetCounter();
    } else {
      count++;
      updateText();
    }
  }

  @override
  void updateText() {
    soundAndVibrateExactValue();
    if (count < 33) {
      currentText.value = StringConstants.subhanallahString;
    } else if (count < 66) {
      currentText.value = StringConstants.elhamdulillahString;
    } else if (count < 99) {
      currentText.value = StringConstants.allahuekberString;
    }
  }

  @override
  void resetCounter() {
    count.value = 1;
    currentText.value = StringConstants.subhanallahString;
    resetPosition();
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
}
