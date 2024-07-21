import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/custom_button.dart';
import 'package:tesbih_app/Components/custom_textfield.dart';
import 'package:tesbih_app/Resources/AppColors.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: const EdgeInsets.only(top: 40),
          icon: const Icon(
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
                style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => CustomTextField(
                  controller: emailController,
                  hintText: 'E-posta',
                  keyboardType: TextInputType.emailAddress,
                  isValid: isEmailValid.value,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomTextField(
                  controller: passwordController,
                  hintText: 'Şifre',
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
                            child: const Text(
                              "Şifrenizi mi unuttunuz?",
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
                    backgroundColor: isAllValid
                        ? const Color.fromARGB(255, 203, 153, 2)
                        : Colors.grey,
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
                    const Text(
                      'Devam ederek,',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryText),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Gizlilik Politikası tapped')),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Gizlilik Politikamızı',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const Text(
                      ' ve ',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryText),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Kullanım Şartları tapped')),
                        );
                      },
                      child: const Text(
                        'Kullanım Şartlarımızı',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const Text(
                      ' kabul etmiş olursunuz.',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.fingerprint, size: 32),
                  onPressed: onBiometricAuthPressed,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
