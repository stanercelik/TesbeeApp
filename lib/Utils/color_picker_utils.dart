import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Resources/picker_colors.dart';

void showColorPicker(
    BuildContext context, Function(Color) onColorChanged, Color currentColor) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(StringConstants.colorPicker),
        content: SingleChildScrollView(
          child: BlockPicker(
            availableColors: standartPickerColors.values.toList(),
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(StringConstants.colorPickerButton),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
