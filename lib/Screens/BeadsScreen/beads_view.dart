import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/draggable_cycle.dart';
import 'package:tesbih_app/Resources/AppColors.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';
import 'package:tesbih_app/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class BeadsView extends StatelessWidget {
  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final UserAuthViewModel authViewModel = Get.put(UserAuthViewModel());

  BeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: beadsViewModel.backgroundColor.value,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: beadsViewModel.backgroundColor.value,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                color: getTextColor(beadsViewModel.backgroundColor.value),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
            'Tesbee',
            style: TextStyle(
              fontSize: 24,
              color: getTextColor(beadsViewModel.backgroundColor.value),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: beadsViewModel.backgroundColor.value,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(color: Colors.black)],
                    color: beadsViewModel.backgroundColor.value,
                  ),
                  child: Text(
                    'Tesbih Ayarları',
                    style: TextStyle(
                        color:
                            getTextColor(beadsViewModel.backgroundColor.value),
                        fontSize: 25),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: beadsViewModel.beadColor.value,
                      border: Border.all(
                          width: 1,
                          color: getTextColor(beadsViewModel.beadColor.value))),
                ),
                title: Text(
                  'Change beads color',
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                ),
                onTap: () {
                  _showColorPicker(
                    context,
                    beadsViewModel.changeBeadColor,
                    beadsViewModel.beadColor.value,
                  );
                },
              ),
              ListTile(
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: beadsViewModel.stringColor.value,
                      border: Border.all(
                          width: 1,
                          color:
                              getTextColor(beadsViewModel.stringColor.value))),
                ),
                title: Text(
                  'Change string color',
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                ),
                onTap: () {
                  _showColorPicker(
                    context,
                    beadsViewModel.changeStringColor,
                    beadsViewModel.stringColor.value,
                  );
                },
              ),
              ListTile(
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: beadsViewModel.backgroundColor.value,
                      border: Border.all(
                          width: 1,
                          color: getTextColor(
                              beadsViewModel.backgroundColor.value))),
                ),
                title: Text(
                  'Change background color',
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                ),
                onTap: () {
                  _showColorPicker(
                    context,
                    beadsViewModel.changeBackgroundColor,
                    beadsViewModel.backgroundColor.value,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.vibration_rounded,
                    color: getTextColor(beadsViewModel.backgroundColor.value)),
                trailing: Switch(
                  activeColor: beadsViewModel.beadColor.value,
                  value: beadsViewModel.isVibration.value,
                  onChanged: (bool newValue) {
                    beadsViewModel.isVibration.value = newValue;
                  },
                ),
                title: Text(
                  'Vibration',
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.alarm_rounded,
                    color: getTextColor(beadsViewModel.backgroundColor.value)),
                title: Text(
                  'Sound Effect',
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                ),
                trailing: Switch(
                  activeColor: beadsViewModel.beadColor.value,
                  value: beadsViewModel.isSoundEffect.value,
                  onChanged: (bool newValue) {
                    beadsViewModel.isSoundEffect.value = newValue;
                  },
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: getTextColor(beadsViewModel.backgroundColor.value),
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: getTextColor(beadsViewModel.backgroundColor.value),
                  ),
                ),
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
                child: DraggableCircle(counterController: beadsViewModel),
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
                        invertColor(getTextColor(
                                beadsViewModel.backgroundColor.value))
                            .withOpacity(0.7),
                        invertColor(getTextColor(
                                beadsViewModel.backgroundColor.value))
                            .withAlpha(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${beadsViewModel.count}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32,
                            color: getTextColor(
                                beadsViewModel.backgroundColor.value),
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        beadsViewModel.currentText.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            color: getTextColor(
                                beadsViewModel.backgroundColor.value),
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
