import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:tesbee/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';
import 'package:tesbee/Services/ad_service.dart';
import 'package:tesbee/Services/language_service.dart';
import 'package:tesbee/Routes/routes.dart';
import 'package:tesbee/Screens/Authflow/SignInFlow/SignInScreen/signin_view.dart';
import 'package:tesbee/Screens/Authflow/SignUpScreen/signup_view.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_view.dart';
import 'package:tesbee/Screens/HomeScreen/home_screen_view.dart';
import 'package:tesbee/Screens/WelcomeScreen/welcome_view.dart';
import 'package:tesbee/Screens/AIChatScreen/ai_chat_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// flutter gen-l10n

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => AdService().init());
  await Get.putAsync(() => LanguageService().init());
  Get.put(UserAuthViewModel());
  runApp(TesbeeApp());
}

class TesbeeApp extends StatelessWidget {
  final UserAuthViewModel userAuthController = Get.put(UserAuthViewModel());
  TesbeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: LanguageService.to.locale,
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      initialRoute: Routes.welcomeScreen,
      getPages: [
        GetPage(
          name: Routes.welcomeScreen,
          page: () => WelcomeView(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: Routes.signInScreen,
          page: () => SignInView(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: Routes.signUpScreen,
          page: () => SignUpView(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: Routes.baseBeadScreen,
          page: () => BeadsView(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: Routes.homeScreen,
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: Routes.aiChatScreen,
          page: () => const AIChatView(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
