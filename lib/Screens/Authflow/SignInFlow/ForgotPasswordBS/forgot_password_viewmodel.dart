import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbih_app/Services/auth_service.dart';

class ForgotPasswordBottomSheetViewModel extends GetxController {
  final AuthService _authService = AuthService();

  var user = Rx<User?>(null);

  final forgotPasswordEmailController = TextEditingController();

  var isForgotPasswordEmailValid = false.obs;
  var isForgotPasswordLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    forgotPasswordEmailController.addListener(validateForgotPasswordEmail);

    user.bindStream(_authService.authStateChanges);
  }

  void validateForgotPasswordEmail() {
    isForgotPasswordEmailValid.value =
        GetUtils.isEmail(forgotPasswordEmailController.text);
  }

  Future<void> forgotPassword({required String email}) async {
    isForgotPasswordLoading.value = true;
    try {
      await _authService.resetPassword(email: email.trim());
      Get.snackbar('Success', 'Password reset email sent to $email');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }
}
