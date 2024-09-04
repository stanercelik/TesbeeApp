import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Resources/app_colors.dart';
import 'package:tesbih_app/Screens/Authflow/BaseAuth/base_auth_view.dart';
import 'package:tesbih_app/Screens/Authflow/SignInFlow/ForgotPasswordBS/forgot_password_view.dart';
import 'package:tesbih_app/Screens/Authflow/SignInFlow/ForgotPasswordBS/forgot_password_viewmodel.dart';
import 'package:tesbih_app/Screens/Authflow/SignInFlow/SignInScreen/signin_viewmodel.dart';

class SignInView extends StatelessWidget {
  final SignInViewModel _signInViewModel = Get.put(SignInViewModel());
  final ForgotPasswordBottomSheetViewModel _bottomSheetViewModel =
      Get.put(ForgotPasswordBottomSheetViewModel());

  SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'E-posta ile giriş yap',
      subtitle: 'E-posta ve şifreni girerek giriş yap',
      buttonText: 'Giriş yap',
      emailController: _signInViewModel.emailController,
      passwordController: _signInViewModel.passwordController,
      isEmailValid: _signInViewModel.isEmailValid,
      isPasswordValid: _signInViewModel.isPasswordValid,
      isLoading: _signInViewModel.isLoading,
      haveForgotPassword: true.obs,
      onButtonPressed: () => _signInViewModel.signIn(),
      onForgotPasswordPressed: () {
        showModalBottomSheet(
          backgroundColor: AppColors.primaryBackground,
          context: context,
          builder: (context) => ForgotPasswordBottomSheet(
            isEmailValid: _bottomSheetViewModel.isForgotPasswordEmailValid,
            emailController:
                _bottomSheetViewModel.forgotPasswordEmailController,
            onSendPressed: () => _bottomSheetViewModel.forgotPassword(
                email:
                    _bottomSheetViewModel.forgotPasswordEmailController.text),
            isLoading: _bottomSheetViewModel.isForgotPasswordLoading,
          ),
        );
      },
      //onBiometricAuthPressed: () => _signInViewModel.signInWithBiometrics(),
    );
  }
}
