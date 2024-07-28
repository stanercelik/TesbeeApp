import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';

void showColorPicker(
    BuildContext context, Function(Color) onColorChanged, Color currentColor) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            availableColors: standartPickerColors.values.toList(),
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
