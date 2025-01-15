import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Services/auth_service.dart';

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
    final l10n = AppLocalizations.of(Get.context!)!;
    isForgotPasswordLoading.value = true;
    try {
      await _authService.resetPassword(email: email.trim());
      Get.snackbar(
        l10n.success, 
        l10n.passwordResetEmailSent(email)
      );
    } catch (e) {
      Get.snackbar(l10n.error, l10n.unknownError);
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }
}
