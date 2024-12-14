import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbee/Screens/DraggableCycleView/draggable_cycle_view_model.dart';

class DraggableCircle extends StatelessWidget {
  final Color stringColor;
  final Color beadColor;
  final int totalCount;
  final RxInt lastCount;
  final DraggableCycleViewModel viewModel;

  const DraggableCircle({
    super.key,
    required this.stringColor,
    required this.beadColor,
    required this.totalCount,
    required this.lastCount,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double circleRadius = MediaQuery.of(context).size.height * 0.035;
    final double movementAreaHeight = screenHeight * 0.15;
    final double maxMovement = movementAreaHeight * 0.47;

    final List<Offset> initialPositions = List.generate(
      13,
      (index) => Offset(0, index * (circleRadius * 2) - screenHeight / 2 + 40),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 6, height: screenHeight, color: stringColor),
        ...List.generate(8, (index) {
          return Obx(() {
            return Transform.translate(
              offset: Offset(
                  0,
                  initialPositions[index].dy +
                      viewModel.beadOffsets[index]
                          .clamp(-maxMovement, maxMovement)),
              child: CircleAvatar(
                  radius: circleRadius, backgroundColor: beadColor),
            );
          });
        }),
        Obx(() => Transform.translate(
              offset: Offset(
                  0,
                  viewModel.offsetY.value.clamp(0, movementAreaHeight) +
                      initialPositions[8].dy +
                      viewModel.beadOffsets[8]
                          .clamp(-maxMovement, maxMovement)),
              child: CircleAvatar(
                radius: circleRadius,
                backgroundColor: beadColor,
              ),
            )),
        ...List.generate(3, (index) {
          return Obx(() {
            return Transform.translate(
              offset: Offset(
                  0,
                  initialPositions[index + 9].dy +
                      movementAreaHeight +
                      viewModel.beadOffsets[index + 8]
                          .clamp(-maxMovement, maxMovement)),
              child: CircleAvatar(
                  radius: circleRadius, backgroundColor: beadColor),
            );
          });
        }),
        GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              viewModel.updatePosition(details.delta.dy);
            }
          },
          onPanEnd: (details) {
            final double threshold = movementAreaHeight * 0.2;
            if (viewModel.offsetY.value > threshold) {
              viewModel.offsetY.value = movementAreaHeight;
            }
            if (viewModel.offsetY.value > movementAreaHeight - circleRadius) {
              viewModel.increment();
              viewModel.resetPosition();
            }
          },
          child: Container(
            color: Colors.transparent,
            height: screenHeight,
            width: screenWidth * 0.8,
          ),
        ),
      ],
    );
  }
}
