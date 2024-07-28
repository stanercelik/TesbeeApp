import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/add_dhikr_color_picker_item.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/dhikr_list_item_view.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/dhikrs_viewmodel.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class AddDhikrBottomSheet extends StatelessWidget {
  const AddDhikrBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());
    final BeadsViewModel beadsViewModel = Get.find<BeadsViewModel>();

    Color backgroundColor = beadsViewModel.backgroundColor.value;
    Color textColor = getTextColor(backgroundColor);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Obx(
              () => TextField(
                onChanged: (value) => dhikrsViewModel.title.value = value,
                decoration: InputDecoration(
                  labelText: 'Dhikr Title',
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                  hintText: "Enter your dhikr's title",
                  errorText: dhikrsViewModel.titleError.value.isNotEmpty
                      ? dhikrsViewModel.titleError.value
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                cursorColor: beadsViewModel.beadColor.value,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Obx(
              () => TextField(
                onChanged: (value) => dhikrsViewModel.totalCount.value = value,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Targeted number of dhikr',
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                  hintText: "Enter the targeted number of your dhikr",
                  errorText: dhikrsViewModel.totalCountError.value.isNotEmpty
                      ? dhikrsViewModel.totalCountError.value
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                cursorColor: beadsViewModel.beadColor.value,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ColorPickerRow(
                    text: "Beads Color",
                    color: dhikrsViewModel.beadColor,
                    onColorChanged: (color) {
                      dhikrsViewModel.beadColor.value = color;
                    },
                    textColor: getTextColor(backgroundColor),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ColorPickerRow(
                    text: "String Color",
                    color: dhikrsViewModel.stringColor,
                    onColorChanged: (color) {
                      dhikrsViewModel.stringColor.value = color;
                    },
                    textColor: getTextColor(backgroundColor),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ColorPickerRow(
                    text: "Background Color",
                    color: dhikrsViewModel.backgroundColor,
                    onColorChanged: (color) {
                      dhikrsViewModel.backgroundColor.value = color;
                    },
                    textColor: getTextColor(backgroundColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: beadsViewModel.beadColor.value),
                onPressed: () {
                  if (dhikrsViewModel.validateAll()) {
                    final newDhikr = DhikrListItemView(
                      title: dhikrsViewModel.title.value,
                      lastCount: '0',
                      dhikrCount: dhikrsViewModel.totalCount.value,
                      backgroundColor: dhikrsViewModel.backgroundColor.value,
                      beadsColor: dhikrsViewModel.beadColor.value,
                      stringColor: dhikrsViewModel.stringColor.value,
                    );
                    dhikrsViewModel.addDhikr(newDhikr);
                    dhikrsViewModel.backgroundColor.value =
                        beadsViewModel.backgroundColor.value;
                    dhikrsViewModel.beadColor.value =
                        beadsViewModel.beadColor.value;
                    dhikrsViewModel.stringColor.value =
                        beadsViewModel.stringColor.value;
                    dhikrsViewModel.title.value = "";
                    dhikrsViewModel.totalCount.value = "";
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Add Dhikr',
                  style: TextStyle(
                      color: getTextColor(beadsViewModel.beadColor.value)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
