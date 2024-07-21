import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Screens/Authflow/BaseAuth/base_auth_view.dart';
import 'package:tesbih_app/Screens/Authflow/SignUpScreen/signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  final SignUpViewModel _signUpViewModel = Get.put(SignUpViewModel());

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'E-posta ile kayıt ol',
      subtitle: 'E-posta ve şifrenizi girin',
      buttonText: 'Hesap Oluştur',
      emailController: _signUpViewModel.emailController,
      passwordController: _signUpViewModel.passwordController,
      isEmailValid: _signUpViewModel.isEmailValid,
      isPasswordValid: _signUpViewModel.isPasswordValid,
      isLoading: _signUpViewModel.isLoading,
      haveForgotPassword: false.obs,
      onButtonPressed: () => _signUpViewModel.createUser(),
      //onBiometricAuthPressed: () => _signUpViewModel.signUpWithBiometrics(),
    );
  }
}
