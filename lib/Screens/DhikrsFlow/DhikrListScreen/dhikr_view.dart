import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Constants/string_constants.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/add_dhikr_bottom_sheet.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/dhikr_list_item_view.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbih_app/Screens/WelcomeScreen/welcome_view.dart';
import 'package:tesbih_app/Services/auth_service.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class DhikrView extends StatelessWidget {
  DhikrView({super.key});

  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());
  final AuthService authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beadsViewModel.backgroundColor.value,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          authService.isAnonymousUser()
              ? const SizedBox(
                  height: 20,
                  width: 20,
                )
              : IconButton(
                  onPressed: () => _onAddDhikrPressed(context),
                  icon: Icon(
                    Icons.add_rounded,
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                  iconSize: 28,
                ),
        ],
        backgroundColor: beadsViewModel.backgroundColor.value,
        title: Text(
          StringConstants.dhikrsScreenTitle,
          style: TextStyle(
            fontSize: 24,
            color: getTextColor(beadsViewModel.backgroundColor.value),
          ),
        ),
      ),
      body: Obx(
        () => authService.isAnonymousUser()
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => Get.to(() => WelcomeView()),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                            'Sign in or Register',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: getTextColor(
                                      beadsViewModel.backgroundColor.value)
                                  .withOpacity(0.8),
                            ),
                          ),
                        )),
                    Text(
                      'to add dhikrs',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            getTextColor(beadsViewModel.backgroundColor.value)
                                .withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              )
            : ListView(
                scrollDirection: Axis.vertical,
                children: dhikrsViewModel.dhikrs
                    .map((dhikr) => DhikrListItemView(dhikr: dhikr))
                    .toList(),
              ),
      ),
    );
  }

  void _onAddDhikrPressed(BuildContext context) async {
    if (await dhikrsViewModel.canAddDhikr()) {
      _showAddDhikrBottomSheet(context);
    } else {
      Get.snackbar(
        StringConstants.limitReached,
        StringConstants.limitReachedText,
        snackPosition: SnackPosition.TOP,
      );
    }
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
