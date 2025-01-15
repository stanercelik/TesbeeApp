import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Components/custom_button.dart';
import 'package:tesbee/Components/custom_textfield.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';

class BaseAuthScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RxBool isEmailValid;
  final RxBool isPasswordValid;
  final RxBool isLoading;
  final RxBool haveForgotPassword;
  final VoidCallback onButtonPressed;
  final VoidCallback? onForgotPasswordPressed;
  final VoidCallback? onBiometricAuthPressed;

  const BaseAuthScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.emailController,
    required this.passwordController,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isLoading,
    required this.onButtonPressed,
    required this.haveForgotPassword,
    this.onForgotPasswordPressed,
    this.onBiometricAuthPressed,
  });

  @override
  Widget build(BuildContext context) {
    final UserAuthViewModel baseAuthViewModel = Get.put(UserAuthViewModel());
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: AppColors.primaryBackground,
        leading: IconButton(
          padding: const EdgeInsets.only(top: 40),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryText,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => CustomTextField(
                  controller: emailController,
                  hintText: l10n.emailLabel,
                  keyboardType: TextInputType.emailAddress,
                  isValid: isEmailValid.value,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomTextField(
                  controller: passwordController,
                  hintText: l10n.passwordLabel,
                  obscureText: true,
                  isValid: isPasswordValid.value,
                  keyboardType: TextInputType.visiblePassword,
                  showValidationIcon: false,
                ),
              ),
              haveForgotPassword.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onForgotPasswordPressed,
                            child: Text(
                              l10n.forgotPassword,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    )
                  : const SizedBox(height: 64),
              Obx(
                () {
                  var isAllValid = isEmailValid.value && isPasswordValid.value;
                  return CustomWideButton(
                    onPressed:
                        isAllValid && !isLoading.value ? onButtonPressed : null,
                    text: buttonText,
                    backgroundColor:
                        isAllValid ? AppColors.primaryButton : Colors.grey,
                    foregroundColor: Colors.white,
                    isLoading: isLoading.value,
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      l10n.byContinuing,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryText),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String markdownData = await baseAuthViewModel
                            .loadMarkdownFile('assets/privacy_policy.md');
                        _showMarkdownDialog(
                            context, l10n.privacyPolicy, markdownData);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          l10n.privacyPolicy,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      l10n.and,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryText),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String markdownData = await baseAuthViewModel
                            .loadMarkdownFile('assets/terms_and_conditions.md');
                        _showMarkdownDialog(
                            context, l10n.termsAndConditions, markdownData);
                      },
                      child: Text(
                        l10n.termsAndConditions,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      l10n.youAccept,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMarkdownDialog(
      BuildContext context, String title, String markdownData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: MarkdownBody(data: markdownData),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
