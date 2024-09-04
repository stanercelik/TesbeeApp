import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbih_app/Screens/HomeScreen/home_screen_view.dart';
import 'package:tesbih_app/Screens/WelcomeScreen/welcome_view.dart';

class UserAuthViewModel extends GetxController {
  static UserAuthViewModel instance = Get.find();
  Rx<User?> firebaseUser = Rx<User?>(null);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => WelcomeView());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  bool isUserSignedIn() {
    return firebaseUser.value != null;
  }

  void signOut() async {
    await auth.signOut();
  }

  Future<String> loadMarkdownFile(String path) async {
    return await rootBundle.loadString(path);
  }
}
