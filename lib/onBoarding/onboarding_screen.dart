import 'package:flutter/material.dart';
import '../utils/app_assets.dart';
import '../utils/app_route.dart';
import 'onboarding_item.dart';
import 'onboarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  List<OnBoardingModel> items = [
    OnBoardingModel(
      image: AppAssets.onborading1,
      title: "Find Your Next Favorite Movie Here",
      subtitle:
      "Get access to a huge library of movies to suit all tastes. You will surely like it.",
    ),
    OnBoardingModel(
      image: AppAssets.onborading2,
      title: "Discover Movies",
      subtitle:
      "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    ),
    OnBoardingModel(
      image: AppAssets.onborading3,
      title: "Explore All Genres",
      subtitle: "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    ),
    OnBoardingModel(
      image: AppAssets.onborading4,
      title: "Create Watchlists",
      subtitle: "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
    ),
    OnBoardingModel(
      image: AppAssets.onborading5,
      title: "Rate, Review, and Learn",
      subtitle: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    ),
    OnBoardingModel(
      image: AppAssets.onborading6,
      title: "Start Watching Now",
      subtitle: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (i) => setState(() => _index = i),
        itemCount: items.length,
        itemBuilder: (_, i) {
          return OnBoardingItem(
            model: items[i],
            isFirstPage: i == 0,
            isLastPage: i == items.length - 1,
            index: i,
            onNext: () {
              if (i == items.length - 1) {
                Navigator.pushReplacementNamed(context, AppRoute.LoginScreen);
              } else {
                _controller.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            onBack: () {
              _controller.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          );
        },
      ),
    );
  }
}
