import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Components/custom_button.dart';
import 'package:tesbih_app/Screens/WelcomeScreen/welcome_viewmodel.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});

  final WelcomeViewModel welcomeViewModel = Get.put(WelcomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                    child: Image.asset("assets/image/tesbee_image.png")),
              )),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  const Text(
                    "Welcome to",
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tes",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 42,
                            color: Colors.black),
                      ),
                      Text(
                        "Bee",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 42,
                            color: Colors.amber),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28.0, horizontal: 16),
                    child: Column(
                      children: [
                        CustomWideButton(
                          onPressed: () {
                            welcomeViewModel.navigateToSignIn();
                          },
                          text: "Sign in with email",
                          backgroundColor: Colors.grey.withOpacity(0.25),
                          foregroundColor: Colors.black,
                          icon: Icons.mail_rounded,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't you have an account?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    welcomeViewModel.navigateToSignUp(),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    "Sign up",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
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
