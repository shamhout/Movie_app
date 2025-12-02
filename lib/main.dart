import 'package:flutter/material.dart';
import 'package:movie_app/ui/browse_tab/browse_tab.dart';
import 'package:movie_app/ui/home/home_screen.dart';
import 'package:movie_app/ui/home_tab/home_tab.dart';
import 'package:movie_app/ui/profile_tab/profile_tab.dart';
import 'package:movie_app/ui/search_tab/search_tab.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_theme.dart';

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
      initialRoute: AppRoute.homeScreen,
      routes: {
        AppRoute.homeScreen: (context) => const HomeScreen(),
        AppRoute.homeTab: (context) => const HomeTab(),
        AppRoute.searchTab: (context) => const SearchTab(),
        AppRoute.browseTab: (context) => const BrowseTab(),
        AppRoute.profileTab: (context) => const ProfileTab(),
      },
    );
  }
}
