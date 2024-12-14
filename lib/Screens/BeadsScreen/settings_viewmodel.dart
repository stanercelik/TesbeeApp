import 'package:get/get.dart';
import 'package:tesbee/Services/settings_service.dart';

class SettingsViewModel extends GetxController {
  final SettingsService _settingsService = SettingsService();

  var beadColor = ''.obs;
  var stringColor = ''.obs;
  var isVibration = false.obs;
  var isSoundEffect = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserSettings();
  }

  Future<void> fetchUserSettings() async {
    final settings = await _settingsService.getUserSettings();
    if (settings != null) {
      beadColor.value = settings['beadColor'] ?? 'defaultColor';
      stringColor.value = settings['stringColor'] ?? 'defaultColor';
      isVibration.value = settings['isVibration'] ?? false;
      isSoundEffect.value = settings['isSoundEffect'] ?? false;
    }
  }

  Future<void> saveSettings() async {
    await _settingsService.saveUserSettings(
      beadColor: beadColor.value,
      stringColor: stringColor.value,
      isVibration: isVibration.value,
      isSoundEffect: isSoundEffect.value,
    );
  }

  void updateBeadColor(String color) {
    beadColor.value = color;
    saveSettings();
  }

  void updateStringColor(String color) {
    stringColor.value = color;
    saveSettings();
  }

  void toggleVibration(bool value) {
    isVibration.value = value;
    saveSettings();
  }

  void toggleSoundEffect(bool value) {
    isSoundEffect.value = value;
    saveSettings();
  }
}
