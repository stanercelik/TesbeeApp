import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbee/Resources/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final InputBorder? borderStyle;
  final InputBorder? disabledBorderStyle;
  final bool isValid;
  final bool showValidationIcon;
  final int maxLine;
  final IconButton? suffixIcon;
  final Function? onSubmitted;
  final TextStyle hintStyle;
  final RxBool obscureTextRx;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isValid = false,
    this.borderStyle =
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    this.disabledBorderStyle =
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    this.maxLine = 1,
    this.hintStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    this.showValidationIcon = true,
    this.suffixIcon,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
  })  : obscureTextRx = obscureText.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        maxLines: maxLine,
        controller: controller,
        obscureText: obscureTextRx.value,
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.deepPurpleAccent,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: (value) {
          if (onSubmitted != null) {
            onSubmitted!(value);
          }
        },
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            enabledBorder: disabledBorderStyle,
            focusedBorder: borderStyle,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            suffixIcon: suffixIcon ??
                (showValidationIcon && isValid
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.primaryText,
                        size: 24,
                      )
                    : obscureText
                        ? IconButton(
                            icon: Icon(
                              obscureTextRx.value
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: Colors.grey,
                              size: 24,
                            ),
                            onPressed: () {
                              obscureTextRx.value = !obscureTextRx.value;
                            },
                          )
                        : null)),
      ),
    );
  }
}
