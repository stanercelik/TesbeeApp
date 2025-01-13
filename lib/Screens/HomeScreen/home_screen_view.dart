import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_view.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikrs_view.dart';
import 'package:tesbee/Screens/HomeScreen/home_screen_viewmodel.dart';
import 'package:tesbee/Screens/AIChatScreen/ai_chat_view.dart';

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
    AIChatView(),
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
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_rounded,
                  color: AppColors.secondaryText,
                  size: 32,
                ),
                activeIcon: Icon(
                  Icons.chat_rounded,
                  color: beadsViewModel.beadColor.value,
                  size: 32,
                ),
                label: 'AI Hoca',
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
