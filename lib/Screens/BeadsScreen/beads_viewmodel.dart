import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Resources/picker_colors.dart';
import 'package:tesbee/Screens/DraggableCycleView/draggable_cycle_view_model.dart';
import 'package:tesbee/Services/ad_service.dart';
import 'package:audioplayers/audioplayers.dart';

class BeadsViewModel extends DraggableCycleViewModel {
  var currentText = StringConstants.subhanallahString.obs;

  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  final AdService adService = Get.put(AdService());
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  var isVibration = true.obs;
  @override
  var isSoundEffect = true.obs;

  @override
  var isVibrating = false.obs;

  @override
  bool shortVibrationPending = false;

  var isComplete = false.obs;

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
    if (lastCount.value < 99) {
      lastCount.value++;

      // Check for special counts and play sound/show notification
      if (lastCount.value == 33 ||
          lastCount.value == 66 ||
          lastCount.value == 99) {
        _playSpecialSound();
        _showCountNotification(lastCount.value);
      }

      if (lastCount.value == 99) {
        isComplete.value = true;
        adService.showInterstitialTesbihatDoneAd();
      }
      updateLastCountInFirestore();
    }
    playSoundAndVibrate();
  }

  void _playSpecialSound() async {
    if (isSoundEffect.value) {
      try {
        await audioPlayer.play(AssetSource('sound/spesific_wooden_click.mp3'));
      } catch (e) {
        print('Error playing special sound: $e');
      }
    }
  }

  void _showCountNotification(int count) {
    String message = '';
    if (count == 33) {
      message = 'Subhanallah 33';
    } else if (count == 66) {
      message = 'Elhamdulillah 66';
    } else if (count == 99) {
      message = 'Allahu Ekber 99';
    }

    Get.snackbar(
      'TesBee',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: beadColor.value,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
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
    lastCount.value = 0;
    isComplete.value = false;
    updateLastCountInFirestore();
    resetPosition();
  }

  void updateLastCountInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('settingsId')
          .update({'lastCount': lastCount.value});
    }
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

  @override
  void onCountChanged(int count) {
    if (count == 33) {
      Get.snackbar(
        'Tebrikler!',
        '33 zikri tamamladınız',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else if (count == 66) {
      Get.snackbar(
        'Tebrikler!',
        '66 zikri tamamladınız',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else if (count == 99) {
      Get.snackbar(
        'Tebrikler!',
        '99 zikri tamamladınız',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
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
}
