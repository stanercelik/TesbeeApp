import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/BeadsScreen/beads_viewmodel.dart';

class DraggableCircle extends StatelessWidget {
  final BeadsViewModel counterController;

  const DraggableCircle({super.key, required this.counterController});

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
        Obx(() => Container(
            width: 6,
            height: screenHeight,
            color: counterController.stringColor.value)),
        ...List.generate(8, (index) {
          return Obx(() {
            return Transform.translate(
              offset: Offset(
                  0,
                  initialPositions[index].dy +
                      counterController.beadOffsets[index]
                          .clamp(-maxMovement, maxMovement)),
              child: CircleAvatar(
                radius: circleRadius,
                backgroundColor: counterController.beadColor.value,
              ),
            );
          });
        }),
        Obx(() => Transform.translate(
              offset: Offset(
                  0,
                  counterController.offsetY.value.clamp(0, movementAreaHeight) +
                      initialPositions[8].dy +
                      counterController.beadOffsets[8]
                          .clamp(-maxMovement, maxMovement)),
              child: CircleAvatar(
                radius: circleRadius,
                backgroundColor: counterController.beadColor.value,
              ),
            )),
        ...List.generate(3, (index) {
          return Obx(() {
            return Transform.translate(
              offset: Offset(
                  0,
                  initialPositions[index + 9].dy +
                      movementAreaHeight +
                      counterController.beadOffsets[index + 8]
                          .clamp(-maxMovement, maxMovement)),
              child: CircleAvatar(
                radius: circleRadius,
                backgroundColor: counterController.beadColor.value,
              ),
            );
          });
        }),
        GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              counterController.updatePosition(details.delta.dy);
            }
          },
          onPanEnd: (details) {
            final double threshold = movementAreaHeight * 0.2;
            if (counterController.offsetY.value > threshold) {
              counterController.offsetY.value = movementAreaHeight;
            }
            if (counterController.offsetY.value >
                movementAreaHeight - circleRadius) {
              counterController.increment();
              counterController.resetPosition();
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
