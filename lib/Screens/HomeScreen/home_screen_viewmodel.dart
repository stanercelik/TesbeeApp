import 'package:get/get.dart';

class HomeScreenViewModel extends GetxController {
  var selectedIndex = 1.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
