import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageService extends GetxService {
  static LanguageService get to => Get.find();
  
  final _locale = const Locale('tr', 'TR').obs;
  Locale get locale => _locale.value;

  Future<LanguageService> init() async {
    setLocaleBasedOnLocation();
    return this;
  }

  void changeLocale(Locale newLocale) {
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
  }

  void setLocaleBasedOnLocation() async {
    // TODO: Implement location check logic here
    // For now, we'll use device locale
    final deviceLocale = Get.deviceLocale;
    if (deviceLocale?.languageCode == 'tr') {
      changeLocale(const Locale('tr', 'TR'));
    } else {
      changeLocale(const Locale('en', 'US'));
    }
  }
}
