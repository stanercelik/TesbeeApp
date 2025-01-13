import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrScreen/dhikr_beads_viewmodel.dart';
import 'package:tesbee/Screens/DraggableCycleView/draggable_cycle.dart';
import 'package:tesbee/Models/dhikr_model.dart';
import 'package:tesbee/Utils/color_utils.dart';
import 'package:tesbee/Services/ad_service.dart';

class DhikrItemScreen extends StatelessWidget {
  final DhikrBeadsViewModel dhikrBeadsViewModel;
  final DhikrsViewModel dhikrsViewModel = Get.find<DhikrsViewModel>();
  final AdService adService = Get.find<AdService>();
  final Dhikr dhikr;

  DhikrItemScreen({Key? key, required this.dhikr}) : 
    dhikrBeadsViewModel = Get.put(DhikrBeadsViewModel(dhikr: dhikr)),
    super(key: key);

  Future<void> _showCompletionAnimation(BuildContext context) async {
    // Ensure isComplete is set to true before showing the animation
    dhikrBeadsViewModel.isComplete.value = true;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/confetti.json',
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) {
                    print('Lottie Error: $error');
                    return const SizedBox.shrink();
                  },
                  onLoaded: (composition) async {
                    await Future.delayed(Duration(
                        milliseconds: composition.duration.inMilliseconds));
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      _showCompletionDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Obx(() {
          if (dhikrBeadsViewModel.isComplete.value) {
            if (GetPlatform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(StringConstants.alertTitle),
                content: Text(StringConstants.alertContent),
                actions: [
                  TextButton(
                    onPressed: () {
                      dhikrBeadsViewModel.resetCounter();
                      adService.showInterstitialAd();
                      Navigator.of(context).pop();
                    },
                    child: Text(StringConstants.alertRestartButton),
                  ),
                  TextButton(
                    onPressed: () {
                      dhikrsViewModel.deleteDhikr(dhikr);
                      Navigator.of(context).pop();
                      Get.back();
                      adService.showInterstitialAd();
                    },
                    child: Text(StringConstants.alertDeleteButton),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                title: Text(StringConstants.alertTitle),
                content: Text(StringConstants.alertContent),
                actions: [
                  TextButton(
                    onPressed: () {
                      dhikrBeadsViewModel.resetCounter();
                      adService.showInterstitialAd();
                      Navigator.of(context).pop();
                    },
                    child: Text(StringConstants.alertRestartButton),
                  ),
                  TextButton(
                    onPressed: () {
                      dhikrsViewModel.deleteDhikr(dhikr);
                      Navigator.of(context).pop();
                      Get.back();
                      adService.showInterstitialAd();
                    },
                    child: Text(StringConstants.alertDeleteButton),
                  ),
                ],
              );
            }
          } else {
            return const SizedBox.shrink();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onComplete: () => _showCompletionAnimation(context),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: adService.getBannerAdWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
