import 'package:flutter/material.dart';

class CustomWideButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isLoading;
  final IconData? icon;

  const CustomWideButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: foregroundColor,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 22),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLoading ? 0 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: 30,
                    ),
                  if (icon != null) const SizedBox(width: 0),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(text),
                ],
              ),
            ),
            if (isLoading)
              CircularProgressIndicator(
                color: foregroundColor,
              ),
          ],
        ),
      ),
    );
  }
}
