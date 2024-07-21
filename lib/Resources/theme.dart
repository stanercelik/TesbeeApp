import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF1E5631), // Yeşil
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Kahverengi
  appBarTheme: AppBarTheme(
    color: const Color(0xFF1E5631),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFFFFFFFF), // Beyaz
        fontSize: 20,
      ),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFFFFFFFF), // Beyaz
        fontSize: 20,
      ),
    ).titleLarge,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFF000000), // Siyah
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF000000), // Siyah
    ),
    displayLarge: TextStyle(
      color: Color(0xFF1E5631), // Yeşil
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1E5631), // Daha koyu yeşil
    secondary: Color(0xFFDAA520), // Daha koyu altın sarısı
    surface: Color(0xFFFFFFFF), // Beyaz
    background: Color(0xFFF5F5F5), // Hafif gri
    error: Color(0xFFB00020), // Kırmızı
    onPrimary: Color(0xFFFFFFFF), // Beyaz
    onSecondary: Color(0xFF000000), // Siyah
    onSurface: Color(0xFF000000), // Siyah
    onBackground: Color(0xFF000000), // Siyah
    onError: Color(0xFFFFFFFF), // Beyaz
  ),
);

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF145A32), // Koyu gri
  scaffoldBackgroundColor: const Color(0xFF121212), // Kahverengi
  appBarTheme: AppBarTheme(
    color: const Color(0xFF145A32),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFFFFFFFF), // Beyaz
        fontSize: 20,
      ),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFFFFFFFF), // Beyaz
        fontSize: 20,
      ),
    ).titleLarge,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFFFFFFFF), // Beyaz
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFFFFFFF), // Beyaz
    ),
    displayLarge: TextStyle(
      color: Color(0xFFC0A006), // Koyu altın sarısı
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF145A32), // Yeşil
    secondary: Color(0xFFC0A006), // Altın sarısı
    surface: Color(0xFF121212), // Koyu gri
    background: Color(0xFF121212), // Koyu gri
    error: Color(0xFFCF6679), // Koyu kırmızı
    onPrimary: Color(0xFFFFFFFF), // Beyaz
    onSecondary: Color(0xFF000000), // Siyah
    onSurface: Color(0xFFFFFFFF), // Beyaz
    onBackground: Color(0xFFFFFFFF), // Beyaz
    onError: Color(0xFF000000), // Siyah
  )
      .copyWith(secondary: const Color(0xFFC0A006))
      .copyWith(background: const Color(0xFF121212)),
);
