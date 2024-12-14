import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbee/Services/auth_service.dart';

class SignUpViewModel extends GetxController {
  final AuthService _authService = AuthService();
  //final BiometricAuthService _biometricAuthService = BiometricAuthService();

  var user = Rx<User?>(null);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);

    user.bindStream(_authService.authStateChanges);
  }

  void validateEmail() {
    isEmailValid.value = GetUtils.isEmail(emailController.text.trim());
  }

  void validatePassword() {
    isPasswordValid.value = passwordController.text.length >= 6;
  }

  Future<void> createUser() async {
    isLoading.value = true;
    try {
      await _authService.createUser(
        email: emailController.text,
        password: passwordController.text,
      );
      /*await _biometricAuthService.storeCredentials(
      emailController.text.trim(),
      passwordController.text,
    );*/
      Get.snackbar('Başarılı', 'Hesap başarıyla oluşturuldu');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Hata',
          'Bu e-posta ile zaten bir hesap oluşturulmuş.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Hata',
          e.message ?? 'Bilinmeyen bir hata oluştu.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /*Future<void> signUpWithBiometrics() async {
    isLoading.value = true;
    try {
      bool isAuthenticated = await _biometricAuthService.authenticate();
      if (isAuthenticated) {
        await createUser();
      } else {
        Get.snackbar(
          'Hata',
          'Biyometrik kimlik doğrulama başarısız veya desteklenmiyor',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }*/
}
