import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_route.dart';

import '../utils/app_assets.dart';
import '../utils/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoute.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Center(
            child: Image.asset(
              AppAssets.logo,
              width: 130,
            ),
          ),

          const Spacer(),

          const Text(
            "Route",
            style: TextStyle(
              color: AppColor.yellow,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Supervised by Mohamed Nabil",
            style: TextStyle(
              color: AppColor.whiteColor,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
