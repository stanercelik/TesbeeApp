import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Resources/picker_colors.dart';
import 'package:tesbee/Screens/DraggableCycleView/draggable_cycle_view_model.dart';
import 'package:tesbee/Services/ad_service.dart';

class BeadsViewModel extends DraggableCycleViewModel {
  var currentText = StringConstants.subhanallahString.obs;

  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  final AdService adService = Get.put(AdService());

  @override
  var isVibration = true.obs;
  @override
  var isSoundEffect = true.obs;

  BeadsViewModel() {
    fetchSettingsFromFirestore();
  }

  void fetchSettingsFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      DocumentSnapshot settingsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('settingsId') // Replace with appropriate settings document ID
          .get();

      if (settingsSnapshot.exists) {
        var data = settingsSnapshot.data() as Map<String, dynamic>;
        beadColor.value = Color(int.parse(data['beadColor']));
        stringColor.value = Color(int.parse(data['stringColor']));
        isVibration.value = data['isVibration'];
        isSoundEffect.value = data['isSoundEffect'];
        backgroundColor.value = Color(int.parse(data['backgroundColor']));
      }
    }
  }

  Future<void> saveSettingsToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('settingsId') // Replace with appropriate settings document ID
          .set({
        'beadColor': beadColor.value.value.toString(),
        'stringColor': stringColor.value.value.toString(),
        'isVibration': isVibration.value,
        'isSoundEffect': isSoundEffect.value,
        'backgroundColor': backgroundColor.value.value.toString(),
      });
    }
  }

  @override
  void increment() {
    playSoundAndVibrate();
    if (lastCount >= 99) {
      adService.showInterstitialTesbihatDoneAd();
      resetCounter();
    } else {
      lastCount++;
      updateText();
    }
  }

  @override
  void updateText() {
    soundAndVibrateExactValue();
    if (lastCount < 33) {
      currentText.value = StringConstants.subhanallahString;
    } else if (lastCount < 66) {
      currentText.value = StringConstants.elhamdulillahString;
    } else if (lastCount < 99) {
      currentText.value = StringConstants.allahuekberString;
    }
  }

  @override
  void resetCounter() {
    lastCount.value = 1;
    currentText.value = StringConstants.subhanallahString;
    resetPosition();
  }

  void changeBeadColor(Color color) {
    beadColor.value = color;
    saveSettingsToFirestore(); // Save settings after change
  }

  void changeStringColor(Color color) {
    stringColor.value = color;
    saveSettingsToFirestore(); // Save settings after change
  }

  void changeBackgroundColor(Color color) {
    backgroundColor.value = color;
    saveSettingsToFirestore(); // Save settings after change
  }

  void toggleVibration(bool value) {
    isVibration.value = value;
    saveSettingsToFirestore(); // Save settings after change
  }

  void toggleSoundEffect(bool value) {
    isSoundEffect.value = value;
    saveSettingsToFirestore(); // Save settings after change
  }
}
