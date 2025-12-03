import 'package:flutter/material.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/ui/browse_tab/browse_tab.dart';
import 'package:movie_app/ui/home/home_screen.dart';
import 'package:movie_app/ui/home_tab/home_tab.dart';
import 'package:movie_app/ui/home_tab/see_more_screen.dart';
import 'package:movie_app/ui/movie_details/movies_details_screen.dart';
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
        AppRoute.movieDetailsScreen: (context) => MovieDetailsScreen(
              movieId: ModalRoute.of(context)!.settings.arguments as int,
            ),
        AppRoute.seeMoreScreen: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return SeeMoreScreen(
            title: args["title"] as String,
            movies: args["movies"] as List<Movies>,
          );
        },
      },
    );
  }
}
