import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/add_dhikr_bottom_sheet.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikr_list_item_view.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbee/Utils/color_utils.dart';

class DhikrView extends StatelessWidget {
  DhikrView({super.key});

  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());
  final UserAuthViewModel userAuthViewModel = Get.put(UserAuthViewModel());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          !userAuthViewModel.isUserSignedIn()
              ? const SizedBox(
                  height: 20,
                  width: 20,
                )
              : IconButton(
                  onPressed: () => _onAddDhikrPressed(context),
                  icon: Icon(
                    Icons.add_rounded,
                    color: getTextColor(AppColors.primaryBackground),
                  ),
                  iconSize: 28,
                ),
        ],
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          l10n.dhikrsScreenTitle,
          style: TextStyle(
            fontSize: 24,
            color: getTextColor(AppColors.primaryBackground),
          ),
        ),
      ),
      body: Obx(
        () => !userAuthViewModel.isUserSignedIn()
            ? Center(
                child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: l10n.dhikrSignInPrompt,
                  style: TextStyle(
                    fontSize: 14,
                    color: getTextColor(AppColors.primaryBackground)
                        .withOpacity(0.4),
                  ),
                  children: [
                    TextSpan(
                      text: l10n.dhikrSignInAction,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: getTextColor(AppColors.primaryBackground)
                            .withOpacity(0.8),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.offAndToNamed('welcomeScreen');
                        },
                    ),
                  ],
                ),
              ))
            : ListView(
                scrollDirection: Axis.vertical,
                children: dhikrsViewModel.dhikrs.isEmpty
                    ? [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              l10n.emptyDhikrListMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: getTextColor(AppColors.primaryBackground).withOpacity(0.7),
                              ),
                            ),
                          ),
                        )
                      ]
                    : dhikrsViewModel.dhikrs
                        .map((dhikr) => DhikrListItemView(dhikr: dhikr))
                        .toList(),
              ),
      ),
    );
  }

  void _onAddDhikrPressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (await dhikrsViewModel.canAddDhikr()) {
      _showAddDhikrBottomSheet(context);
    } else {
      Get.snackbar(
        l10n.dhikrLimitReached,
        l10n.dhikrLimitReachedText,
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
