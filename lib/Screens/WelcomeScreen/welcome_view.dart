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
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                    child: Image.asset(
                  "assets/image/deneme.png",
                )),
              )),
          Expanded(
              flex: 7,
              child: Column(
                children: [
                  Text(
                    "Hoş Geldin",
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: AppColors.primaryText),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tes",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 42,
                            color: AppColors.primaryText),
                      ),
                      const Text(
                        "Bee",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 42,
                            color: AppColors.primaryButton),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16),
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
                        const SizedBox(
                          height: 16,
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hesabın yok mu?",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.75)),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    welcomeViewModel.navigateToSignUp(),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    "Kaydol",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryButton),
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
              )),
        ],
      ),
    );
  }
}
