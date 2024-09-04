import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Constants/string_constants.dart';
import 'package:tesbih_app/Resources/app_colors.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_view.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/dhikrs_view.dart';

import 'package:tesbih_app/Screens/HomeScreen/home_screen_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenViewModel homeScreenController =
      Get.put(HomeScreenViewModel());

  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());

  final List _pages = [
    DhikrView(),
    BeadsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _pages[homeScreenController.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.primaryBackground,
            items: [
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "assets/icon/prayIcon.png",
                  color: beadsViewModel.beadColor.value,
                  width: 35,
                  height: 35,
                ),
                icon: Image.asset(
                  "assets/icon/prayIcon.png",
                  color: AppColors.secondaryText,
                  width: 35,
                  height: 35,
                ),
                label: StringConstants.bottomNavBarDhikrs,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icon/rosary_white.png',
                  color: AppColors.secondaryText,
                  width: 45,
                  height: 45,
                ),
                activeIcon: Image.asset(
                  'assets/icon/rosary_white.png',
                  color: beadsViewModel.beadColor.value,
                  width: 45,
                  height: 45,
                ),
                label: StringConstants.bottomNavBarBeads,
              ),
            ],
            currentIndex: homeScreenController.selectedIndex.value,
            selectedItemColor: beadsViewModel.beadColor.value,
            unselectedItemColor: Colors.grey,
            onTap: homeScreenController.onItemTapped,
          ),
        );
      }),
    );
  }
}
