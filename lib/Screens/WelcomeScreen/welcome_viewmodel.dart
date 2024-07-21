import 'package:get/get.dart';

class WelcomeViewModel extends GetxController {
  void navigateToSignIn() {
    Get.toNamed('/signin');
  }

  void navigateToSignUp() {
    Get.toNamed('/signup');
  }
}
