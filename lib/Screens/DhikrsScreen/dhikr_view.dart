import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/dhikr_list_item_view.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/dhikrs_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/add_dhikr_bottom_sheet.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class DhikrView extends StatelessWidget {
  DhikrView({super.key});

  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beadsViewModel.backgroundColor.value,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showAddDhikrBottomSheet(context),
            icon: Icon(
              Icons.add_rounded,
              color: getTextColor(beadsViewModel.backgroundColor.value),
            ),
            iconSize: 28,
          ),
        ],
        backgroundColor: beadsViewModel.backgroundColor.value,
        title: Text(
          'Dhikrs',
          style: TextStyle(
            fontSize: 24,
            color: getTextColor(beadsViewModel.backgroundColor.value),
          ),
        ),
      ),
      body: Obx(() => ListView(
            scrollDirection: Axis.vertical,
            children: dhikrsViewModel.dhikrs
                .map((dhikr) => DhikrListItemView(dhikr: dhikr))
                .toList(),
          )),
    );
  }

  void _showAddDhikrBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddDhikrBottomSheet(),
      ),
    );
  }
}
