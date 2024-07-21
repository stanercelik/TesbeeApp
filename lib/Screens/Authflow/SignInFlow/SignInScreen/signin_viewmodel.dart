import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbih_app/Services/auth_service.dart';

class SignInViewModel extends GetxController {
  final AuthService _authService = AuthService();
  //final BiometricAuthService _biometricAuthService = BiometricAuthService();

  var user = Rx<User?>(null);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isEmailValid = false.obs;
  var isForgotPasswordEmailValid = false.obs;
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
    isEmailValid.value = GetUtils.isEmail(emailController.text);
  }

  void validatePassword() {
    isPasswordValid.value = passwordController.text.length >= 6;
  }

  Future<void> signIn() async {
    isLoading.value = true;
    try {
      await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.snackbar(
        'Success',
        'Signed in successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /*Future<void> signInWithBiometrics() async {
    isLoading.value = true;
    try {
      bool isAuthenticated = await _biometricAuthService.authenticate();
      if (isAuthenticated) {
        var credentials = await _biometricAuthService.getStoredCredentials();
        if (credentials['email'] != null && credentials['password'] != null) {
          await _authService.signIn(
            email: credentials['email']!.trim(),
            password: credentials['password']!,
          );
          Get.snackbar(
            'Success',
            'Authenticated successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Stored credentials not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Biometric authentication failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }*/

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
