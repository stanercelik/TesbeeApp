import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_view.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/dhikr_view.dart';
import 'package:tesbih_app/Screens/ProfileScreen/profile_view.dart';
import 'package:tesbih_app/Screens/HomeScreen/home_screen_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenViewModel homeScreenController =
      Get.put(HomeScreenViewModel());

  final List<Widget> _pages = [
    const DhikrView(),
    BeadsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _pages[homeScreenController.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              label: 'Zikirler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit_rounded),
              label: 'Tesbih',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
          currentIndex: homeScreenController.selectedIndex.value,
          selectedItemColor: Colors.amber[800],
          onTap: homeScreenController.onItemTapped,
        );
      }),
    );
  }
}
