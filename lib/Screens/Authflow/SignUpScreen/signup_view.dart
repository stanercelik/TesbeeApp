import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Screens/Authflow/BaseAuth/base_auth_view.dart';
import 'package:tesbee/Screens/Authflow/SignUpScreen/signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  final SignUpViewModel _signUpViewModel = Get.put(SignUpViewModel());

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BaseAuthScreen(
      title: l10n.signUpWithEmail,
      subtitle: l10n.enterEmailPassword,
      buttonText: l10n.createAccount,
      emailController: _signUpViewModel.emailController,
      passwordController: _signUpViewModel.passwordController,
      isEmailValid: _signUpViewModel.isEmailValid,
      isPasswordValid: _signUpViewModel.isPasswordValid,
      isLoading: _signUpViewModel.isLoading,
      haveForgotPassword: false.obs,
      onButtonPressed: () => _signUpViewModel.createUser(),
    );
  }
}
