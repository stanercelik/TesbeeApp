import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/custom_button.dart';
import 'package:tesbih_app/Resources/app_colors.dart';
import 'package:tesbih_app/Screens/WelcomeScreen/welcome_viewmodel.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});

  final WelcomeViewModel welcomeViewModel = Get.put(WelcomeViewModel());

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final double imageHeight =
        screenSize.height * 0.35; // Adjusted to be 35% of screen height
    final double padding =
        screenSize.width * 0.05; // 5% of screen width as padding

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: SizedBox(
                height: imageHeight,
                child: Image.asset(
                  "assets/image/deneme.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hoş Geldin",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.1, // 10% of screen width
                    fontWeight: FontWeight.w300,
                    color: AppColors.primaryText,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tes",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenSize.width * 0.09, // 9% of screen width
                        color: AppColors.primaryText,
                      ),
                    ),
                    const Text(
                      "Bee",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 42,
                        color: AppColors.primaryButton,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02, // 2% of screen height
                      horizontal: padding),
                  child: Column(
                    children: [
                      CustomWideButton(
                        onPressed: () {
                          welcomeViewModel.exploreTheApp();
                        },
                        text: "Uygulamayı keşfet",
                        backgroundColor: AppColors.primaryButton,
                        foregroundColor: Colors.black,
                        icon: Icons.person_outline_rounded,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.02, // 2% of screen height
                      ),
                      CustomWideButton(
                        onPressed: () {
                          welcomeViewModel.navigateToSignIn();
                        },
                        text: "E-posta ile giriş yap",
                        backgroundColor: Colors.white.withOpacity(0.75),
                        foregroundColor: Colors.black,
                        icon: Icons.mail_rounded,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                screenSize.height * 0.01 // 1% of screen height
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hesabın yok mu?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: screenSize.width *
                                    0.04, // 4% of screen width
                              ),
                            ),
                            GestureDetector(
                              onTap: () => welcomeViewModel.navigateToSignUp(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  "Kaydol",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryButton,
                                    fontSize: screenSize.width *
                                        0.04, // 4% of screen width
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
