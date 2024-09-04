import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/add_dhikr_color_picker_item.dart';
import 'package:tesbih_app/Constants/string_constants.dart';
import 'package:tesbih_app/Models/dhikr_model.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbih_app/Services/ad_service.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class AddDhikrBottomSheet extends StatelessWidget {
  final Dhikr? editDhikr;

  const AddDhikrBottomSheet({super.key, this.editDhikr});

  @override
  Widget build(BuildContext context) {
    final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());
    final BeadsViewModel beadsViewModel = Get.find<BeadsViewModel>();
    final AdService adService = Get.put(AdService());

    final TextEditingController titleController = TextEditingController();
    final TextEditingController totalCountController = TextEditingController();

    if (editDhikr != null) {
      dhikrsViewModel.title.value = editDhikr!.title;
      dhikrsViewModel.totalCount.value = editDhikr!.totalCount.toString();
      dhikrsViewModel.beadColor.value = editDhikr!.beadsColor;
      dhikrsViewModel.stringColor.value = editDhikr!.stringColor;
      dhikrsViewModel.backgroundColor.value = editDhikr!.backgroundColor;

      titleController.text = dhikrsViewModel.title.value;
      totalCountController.text = dhikrsViewModel.totalCount.value;
    } else {
      dhikrsViewModel.backgroundColor.value =
          beadsViewModel.backgroundColor.value;
      dhikrsViewModel.beadColor.value = beadsViewModel.beadColor.value;
      dhikrsViewModel.stringColor.value = beadsViewModel.stringColor.value;
    }

    Color backgroundColor = dhikrsViewModel.backgroundColor.value;
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
                onChanged: (value) {
                  dhikrsViewModel.title.value = value;
                },
                controller: titleController,
                decoration: InputDecoration(
                  labelText: StringConstants.addDhikrTitle,
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                  hintText: StringConstants.addDhikrTitleHint,
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
                onChanged: (value) {
                  dhikrsViewModel.totalCount.value = value;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: totalCountController,
                decoration: InputDecoration(
                  labelText: StringConstants.addDhikrTargetNum,
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                  hintText: StringConstants.addDhikrTargetNumHint,
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: ColorPickerRow(
                    text: StringConstants.addDhikrBeadsColor,
                    color: dhikrsViewModel.beadColor,
                    onColorChanged: (color) {
                      dhikrsViewModel.beadColor.value = color;
                    },
                    textColor: getTextColor(backgroundColor),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ColorPickerRow(
                    text: StringConstants.addDhikrStringColor,
                    color: dhikrsViewModel.stringColor,
                    onColorChanged: (color) {
                      dhikrsViewModel.stringColor.value = color;
                    },
                    textColor: getTextColor(backgroundColor),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ColorPickerRow(
                    text: StringConstants.addDhikrBackgroundColor,
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
                  backgroundColor: beadsViewModel.beadColor.value,
                ),
                onPressed: () {
                  if (dhikrsViewModel.validateAll()) {
                    final updatedDhikr = Dhikr(
                      id: editDhikr?.id ?? '',
                      title: dhikrsViewModel.title.value,
                      beadsColor: dhikrsViewModel.beadColor.value,
                      stringColor: dhikrsViewModel.stringColor.value,
                      backgroundColor: dhikrsViewModel.backgroundColor.value,
                      totalCount: dhikrsViewModel.totalCount.value,
                      lastCount: editDhikr?.lastCount ?? 0,
                      timestamp: Timestamp.now(),
                    );

                    if (editDhikr != null) {
                      dhikrsViewModel.updateDhikr(updatedDhikr);
                    } else {
                      dhikrsViewModel.addDhikr(updatedDhikr);
                    }

                    dhikrsViewModel.title.value = "";
                    dhikrsViewModel.totalCount.value = "";
                    adService.showInterstitialAd();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  editDhikr != null
                      ? StringConstants.editDhikrButton
                      : StringConstants.addDhikrButton,
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.beadColor.value),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
