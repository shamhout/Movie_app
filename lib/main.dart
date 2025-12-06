import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_app/splash/splash_screen.dart';
import 'package:movie_app/ui/auth/login/login_screen.dart';
import 'package:movie_app/ui/browse_tab/browse_tab.dart';
import 'package:movie_app/ui/home/home_screen.dart';
import 'package:movie_app/ui/home_tab/home_tab.dart';
import 'package:movie_app/ui/profile_tab/profile_tab.dart';
import 'package:movie_app/ui/search_tab/search_tab.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_theme.dart';
import 'onBoarding/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,

      // ====== Localization ======
      locale: const Locale("en"), // اللغة الافتراضية
      supportedLocales: const [
        Locale("en"),
        Locale("ar"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ==========================

      initialRoute: AppRoute.splashScreen,
      routes: {
        AppRoute.splashScreen: (context) => const SplashScreen(),
        AppRoute.homeScreen: (context) => const HomeScreen(),
        AppRoute.homeTab: (context) => const HomeTab(),
        AppRoute.searchTab: (context) => const SearchTab(),
        AppRoute.browseTab: (context) => const BrowseTab(),
        AppRoute.profileTab: (context) => const ProfileTab(),
        AppRoute.onboarding: (context) => const OnBoardingScreen(),
        AppRoute.loginScreen: (context) => const LoginScreen(),

      },
    );
  }
}
