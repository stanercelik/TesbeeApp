import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Components/custom_button.dart';
import 'package:tesbee/Components/custom_textfield.dart';
import 'package:tesbee/Resources/app_colors.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSendPressed;
  final RxBool isLoading;
  final RxBool isEmailValid;

  const ForgotPasswordBottomSheet({
    super.key,
    required this.emailController,
    required this.onSendPressed,
    required this.isLoading,
    required this.isEmailValid,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, bottom: 32, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              () {
                return CustomWideButton(
                  onPressed: isEmailValid.value && !isLoading.value
                      ? () {
                          onSendPressed();
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        }
                      : null,
                  text: l10n.sendResetLink,
                  backgroundColor: isEmailValid.value
                      ? AppColors.primaryButton
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  isLoading: isLoading.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
