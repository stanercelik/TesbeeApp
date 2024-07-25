import 'package:flutter/material.dart';

Color getTextColor(Color backgroundColor) {
  double luminance = (0.299 * backgroundColor.red +
          0.587 * backgroundColor.green +
          0.114 * backgroundColor.blue) /
      255;
  return luminance > 0.5 ? Colors.black : Colors.white;
}

Color invertColor(Color color) {
  return Color.fromARGB(
    color.alpha,
    255 - color.red,
    255 - color.green,
    255 - color.blue,
  );
}
