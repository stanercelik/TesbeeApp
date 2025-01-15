import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Resources/picker_colors.dart';

void showColorPicker(
    BuildContext context, Function(Color) onColorChanged, Color currentColor) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.colorPicker),
        content: SingleChildScrollView(
          child: BlockPicker(
            availableColors: standartPickerColors.values.toList(),
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(l10n.selectColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
