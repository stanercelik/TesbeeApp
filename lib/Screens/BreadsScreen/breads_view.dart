import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/draggable_cycle.dart';
import 'package:tesbih_app/Resources/AppColors.dart';
import 'package:tesbih_app/Screens/BreadsScreen/breads_viewmodel.dart';

class BreadsView extends StatelessWidget {
  final BreadsViewModel counterController = Get.put(BreadsViewModel());

  BreadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
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
        title: const Center(
          child: Text(
            'Tesbee',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 120.0,
              decoration: const BoxDecoration(
                color: AppColors.primaryBackground,
              ),
              child: const Text(
                'Ayarlar',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Handle the tap event
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle the tap event
                Navigator.pop(context);
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
    );
  }
}
