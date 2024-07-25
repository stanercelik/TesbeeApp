import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/draggable_cycle.dart';
import 'package:tesbih_app/Resources/AppColors.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';
import 'package:tesbih_app/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BeadsView extends StatelessWidget {
  final BeadsViewModel counterController = Get.put(BeadsViewModel());
  final UserAuthViewModel authViewModel = Get.put(UserAuthViewModel());

  BeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: counterController.backgroundColor.value,
        appBar: AppBar(
          backgroundColor: counterController.backgroundColor.value,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: const Text(
            'Tesbee',
            style: TextStyle(fontSize: 24),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 200,
                child: DrawerHeader(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: counterController.beadColor.value,
                      border: Border.all(width: 1)),
                ),
                title: const Text('Change beads color'),
                onTap: () {
                  _showColorPicker(
                    context,
                    counterController.changeBeadColor,
                    counterController.beadColor.value,
                  );
                },
              ),
              ListTile(
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: counterController.stringColor.value,
                      border: Border.all(width: 1)),
                ),
                title: const Text('Change string color'),
                onTap: () {
                  _showColorPicker(
                    context,
                    counterController.changeStringColor,
                    counterController.stringColor.value,
                  );
                },
              ),
              ListTile(
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: counterController.backgroundColor.value,
                      border: Border.all(width: 1)),
                ),
                title: const Text('Change background color'),
                onTap: () {
                  _showColorPicker(
                    context,
                    counterController.changeBackgroundColor,
                    counterController.backgroundColor.value,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Sign Out'),
                onTap: () {
                  authViewModel.signOut();
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: DraggableCircle(counterController: counterController),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Obx(
                () => Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${counterController.count}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        counterController.currentText.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, Function(Color) onColorChanged,
      Color currentColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              availableColors: pickerColors.values.toList(),
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
