import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbee/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbee/Services/ad_service.dart';
import 'package:tesbee/Routes/routes.dart';
import 'package:tesbee/Screens/Authflow/SignInFlow/SignInScreen/signin_view.dart';
import 'package:tesbee/Screens/Authflow/SignUpScreen/signup_view.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_view.dart';
import 'package:tesbee/Screens/HomeScreen/home_screen_view.dart';
import 'package:tesbee/Screens/WelcomeScreen/welcome_view.dart';
import 'package:tesbee/Screens/AIChatScreen/ai_chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => AdService().init());
  Get.put(UserAuthViewModel());
  Get.put(DhikrsViewModel());
  runApp(TesbeeApp());
}

class TesbeeApp extends StatelessWidget {
  final UserAuthViewModel userAuthController = Get.put(UserAuthViewModel());
  TesbeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      getPages: [
        GetPage(name: Routes.welcomeScreen, page: () => WelcomeView()),
        GetPage(name: Routes.signInScreen, page: () => SignInView()),
        GetPage(name: Routes.signUpScreen, page: () => SignUpView()),
        GetPage(name: Routes.baseBeadScreen, page: () => BeadsView()),
        GetPage(name: Routes.homeScreen, page: () => const HomeScreen()),
        GetPage(name: Routes.aiChatScreen, page: () => const AIChatView()),
      ],
    );
  }
}
