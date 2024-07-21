// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Routes/routes.dart';
import 'package:tesbih_app/Screens/BreadsScreen/breads_view.dart';
import 'package:tesbih_app/Screens/WelcomeScreen/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TesbeeApp());
}

class TesbeeApp extends StatelessWidget {
  const TesbeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeView(),
      getPages: [
        GetPage(name: Routes.welcomeScreen, page: () => WelcomeView()),
        GetPage(name: Routes.signInScreen, page: () => WelcomeView()),
        GetPage(name: Routes.signUpScreen, page: () => WelcomeView()),
        GetPage(name: Routes.baseBreadScreen, page: () => BreadsView()),
      ],
    );
  }
}
