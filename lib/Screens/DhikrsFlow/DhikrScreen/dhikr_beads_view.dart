import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrScreen/dhikr_beads_viewmodel.dart';
import 'package:tesbee/Screens/DraggableCycleView/draggable_cycle.dart';
import 'package:tesbee/Models/dhikr_model.dart';
import 'package:tesbee/Utils/color_utils.dart';
import 'package:tesbee/Services/ad_service.dart';

class DhikrItemScreen extends StatelessWidget {
  final Dhikr dhikr;

  const DhikrItemScreen({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final DhikrBeadsViewModel dhikrBeadsViewModel =
        Get.put(DhikrBeadsViewModel(dhikr: dhikr));
    final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());
    final AdService adService = Get.put(AdService());

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: dhikr);
        return false;
      },
      child: Scaffold(
        backgroundColor: dhikr.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          title: Text(
            dhikr.title,
            style: TextStyle(
              fontSize: 24,
              color: getTextColor(AppColors.primaryBackground),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: getTextColor(AppColors.primaryBackground),
            ),
            iconSize: 36,
            onPressed: () {
              Get.back(result: dhikr);
            },
          ),
          actions: [
            Obx(() {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Text(
                  '${dhikrBeadsViewModel.lastCount}/${dhikr.totalCount}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: getTextColor(AppColors.primaryBackground),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: DraggableCircle(
                stringColor: dhikr.stringColor,
                beadColor: dhikr.beadsColor,
                totalCount: int.parse(dhikr.totalCount),
                lastCount: dhikrBeadsViewModel.lastCount,
                viewModel: dhikrBeadsViewModel,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBackground.withOpacity(0.75),
                      invertColor(getTextColor(dhikr.backgroundColor))
                          .withAlpha(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 4),
                      child: Text(
                        dhikrBeadsViewModel.dhikr.pray,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: getTextColor(dhikr.backgroundColor),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: adService.getBannerAdWidget(),
            ),
            Obx(() {
              if (dhikrBeadsViewModel.isComplete.value) {
                if (GetPlatform.isIOS) {
                  return Center(
                    child: CupertinoAlertDialog(
                      title: Text(StringConstants.alertTitle),
                      content: Text(StringConstants.alertContent),
                      actions: [
                        TextButton(
                          onPressed: () {
                            dhikrBeadsViewModel.resetCounter();
                            adService.showInterstitialAd();
                          },
                          child: Text(StringConstants.alertRestartButton),
                        ),
                        TextButton(
                          onPressed: () {
                            dhikrsViewModel.deleteDhikr(dhikr);
                            Get.back();
                            Get.back();
                            adService.showInterstitialAd();
                          },
                          child: Text(StringConstants.alertDeleteButton),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: AlertDialog(
                      title: Text(StringConstants.alertTitle),
                      content: Text(StringConstants.alertContent),
                      actions: [
                        TextButton(
                          onPressed: () {
                            dhikrBeadsViewModel.resetCounter();
                            adService.showInterstitialAd();
                          },
                          child: Text(StringConstants.alertRestartButton),
                        ),
                        TextButton(
                          onPressed: () {
                            dhikrsViewModel.deleteDhikr(dhikr);
                            Get.back();
                            Get.back();
                            adService.showInterstitialAd();
                          },
                          child: Text(StringConstants.alertDeleteButton),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
