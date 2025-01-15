import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbee/Routes/routes.dart';

class UserAuthViewModel extends GetxController {
  static UserAuthViewModel instance = Get.find();
  Rx<User?> firebaseUser = Rx<User?>(null);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, navigateBasedOnAuth);
  }

  void navigateBasedOnAuth(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.welcomeScreen);
    } else {
      Get.offAllNamed(Routes.homeScreen);
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
