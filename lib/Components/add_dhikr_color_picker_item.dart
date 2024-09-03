import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Utils/color_picker_utils.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class ColorPickerRow extends StatelessWidget {
  final String text;
  final Rx<Color> color;
  final Function(Color) onColorChanged;
  final Color textColor;

  const ColorPickerRow({
    Key? key,
    required this.text,
    required this.color,
    required this.onColorChanged,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => showColorPicker(context, (selectedColor) {
          onColorChanged(selectedColor);
        }, color.value),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
              Obx(() => Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: getTextColor(color.value)),
                      color: color.value,
                      shape: BoxShape.circle,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
