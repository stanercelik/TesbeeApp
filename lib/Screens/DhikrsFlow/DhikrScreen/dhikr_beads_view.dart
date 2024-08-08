import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrScreen/dhikr_beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DraggableCycleView/draggable_cycle.dart';
import 'package:tesbih_app/Models/dhikr_model.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class DhikrItemScreen extends StatelessWidget {
  final Dhikr dhikr;

  const DhikrItemScreen({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final DhikrBeadsViewModel dhikrBeadsViewModel =
        Get.put(DhikrBeadsViewModel(dhikr: dhikr));
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: dhikr);
        return false;
      },
      child: Scaffold(
        backgroundColor: dhikr.backgroundColor,
        appBar: AppBar(
          backgroundColor: dhikr.backgroundColor,
          title: Text(
            dhikr.title,
            style: TextStyle(
              fontSize: 24,
              color: getTextColor(dhikr.backgroundColor),
            ),
          ),
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
                      invertColor(getTextColor(dhikr.backgroundColor))
                          .withOpacity(0.7),
                      invertColor(getTextColor(dhikr.backgroundColor))
                          .withAlpha(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Obx(() => Text(
                          '${dhikrBeadsViewModel.lastCount}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            color: getTextColor(dhikr.backgroundColor),
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
