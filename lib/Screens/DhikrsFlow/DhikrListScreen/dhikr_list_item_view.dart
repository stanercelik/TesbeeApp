import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Constants/string_constants.dart';
import 'package:tesbih_app/Models/dhikr_model.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/add_dhikr_bottom_sheet.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrScreen/dhikr_beads_view.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbih_app/Utils/color_utils.dart';
import 'package:tesbih_app/Utils/slideable_button.dart';

class DhikrListItemView extends StatelessWidget {
  const DhikrListItemView({
    required this.dhikr,
    super.key,
  });

  final Dhikr dhikr;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = dhikr.backgroundColor;
    final stringColor = dhikr.stringColor;
    final beadsColor = dhikr.beadsColor;
    final DhikrsViewModel dhikrsViewModel = Get.find<DhikrsViewModel>();

    return Slidable(
      key: Key(dhikr.id),
      endActionPane: ActionPane(
        extentRatio: 0.45,
        motion: const ScrollMotion(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: context.height,
              width: context.width * 0.2,
              child: SlidableButton(
                onPressed: (context) => _editDhikr(context, dhikr),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: StringConstants.editDhikr,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: context.height,
              width: context.width * 0.2,
              child: SlidableButton(
                onPressed: (context) => _deleteDhikr(dhikrsViewModel, dhikr),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: StringConstants.deleteDhikr,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          Dhikr? updatedDhikr =
              await Get.to(() => DhikrItemScreen(dhikr: dhikr));
          if (updatedDhikr != null) {
            dhikr.lastCount = updatedDhikr.lastCount;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: getTextColor(backgroundColor)),
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          dhikr.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: getTextColor(backgroundColor),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          "${dhikr.lastCount}/${dhikr.totalCount}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: getTextColor(backgroundColor),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 42.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 3,
                        color: stringColor,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: beadsColor,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: beadsColor,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: beadsColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editDhikr(BuildContext context, Dhikr dhikr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddDhikrBottomSheet(editDhikr: dhikr),
      ),
    );
  }

  void _deleteDhikr(DhikrsViewModel dhikrsViewModel, Dhikr dhikr) {
    dhikrsViewModel.deleteDhikr(dhikr);
  }
}
