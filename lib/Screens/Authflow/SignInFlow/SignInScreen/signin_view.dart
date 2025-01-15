import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/Authflow/BaseAuth/base_auth_view.dart';
import 'package:tesbee/Screens/Authflow/SignInFlow/ForgotPasswordBS/forgot_password_view.dart';
import 'package:tesbee/Screens/Authflow/SignInFlow/ForgotPasswordBS/forgot_password_viewmodel.dart';
import 'package:tesbee/Screens/Authflow/SignInFlow/SignInScreen/signin_viewmodel.dart';

class SignInView extends StatelessWidget {
  final SignInViewModel _signInViewModel = Get.put(SignInViewModel());
  final ForgotPasswordBottomSheetViewModel _bottomSheetViewModel =
      Get.put(ForgotPasswordBottomSheetViewModel());

  SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BaseAuthScreen(
      title: l10n.signInTitle,
      subtitle: l10n.signInSubtitle,
      buttonText: l10n.signInButton,
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
    );
  }
}
