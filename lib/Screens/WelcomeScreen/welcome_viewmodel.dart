import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Services/auth_service.dart';

class WelcomeViewModel extends GetxController {
  void navigateToSignIn() {
    Get.toNamed('/signin');
  }

  void navigateToSignUp() {
    Get.toNamed('/signup');
  }
}
