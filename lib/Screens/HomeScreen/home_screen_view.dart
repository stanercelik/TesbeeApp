import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_view.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsFlow/DhikrListScreen/dhikr_view.dart';

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
            backgroundColor: beadsViewModel.backgroundColor.value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book_rounded),
                label: 'Zikirler',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit_rounded),
                label: 'Tesbih',
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
