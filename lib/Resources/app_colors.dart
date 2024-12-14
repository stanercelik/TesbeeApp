import 'package:flutter/material.dart';
import 'package:tesbee/Resources/picker_colors.dart';
import 'package:tesbee/Utils/color_utils.dart';

class AppColors {
  // Arka Plan Renkleri
  static Color primaryBackground = premiumPickerColors["dimgray"]!; // Bej

  // Yazı Renkleri
  static Color primaryText = getTextColor(primaryBackground);
  static Color secondaryText =
      getTextColor(primaryBackground).withOpacity(0.75);

  // Buton Renkleri
  static const Color primaryButton = Color.fromARGB(255, 203, 153, 2);

  static const Color primaryButtonText = Color(0xFFFFFFFF); // Beyaz
  static const Color secondaryButton = Color(0xFF4CAF50); // Açık Yeşil
  static const Color secondaryButtonText = Color(0xFFFFFFFF); // Beyaz
  // Vurgu Renkleri
  static const Color accent = Color(0xFFFFEB3B); // Açık Altın
  static const Color link = Color(0xFF2196F3); // Orta Mavi

  // Kenar ve Çerçeve Renkleri
  static const Color border = Color(0xFFD7CCC8); // Açık Kahverengi
  static const Color frame = Color(0xFF1B5E20); // Daha Koyu Yeşil

  // Gölgeler ve Diğer Detaylar
  static const Color shadow = Color(0xFF9E9E9E); // Gri
  static const Color icon = Color(0xFF03A9F4); // Açık Mavi
}
