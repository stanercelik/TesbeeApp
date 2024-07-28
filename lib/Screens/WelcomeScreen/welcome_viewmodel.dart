import 'package:get/get.dart';
import 'package:tesbih_app/Services/auth_service.dart';

class WelcomeViewModel extends GetxController {
  final AuthService _authService = AuthService();

  void navigateToSignIn() {
    Get.toNamed('/signin');
  }

  void navigateToSignUp() {
    Get.toNamed('/signup');
  }

  void signInAnonymously() async {
    try {
      await _authService.signInAnonymously();
      Get.snackbar('Success', 'Signed in anonymously');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
