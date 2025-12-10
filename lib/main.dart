import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/locale/localization.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_bloc.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:movie_app/splash/splash_screen.dart';
import 'package:movie_app/ui/auth/ForgetPassword.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/ui/auth/Login.dart';
import 'package:movie_app/ui/auth/Register.dart';
import 'package:movie_app/ui/browse_tab/browse_tab.dart';
import 'package:movie_app/ui/home/home_screen.dart';
import 'package:movie_app/ui/home_tab/home_tab.dart';
import 'package:movie_app/ui/home_tab/see_more_screen.dart';
import 'package:movie_app/ui/movie_details/movies_details_screen.dart';
import 'package:movie_app/ui/profile_tab/profile_tab.dart';
import 'package:movie_app/ui/search_tab/search_tab.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_theme.dart';
import 'package:movie_app/views/update_profile.dart';
import 'onBoarding/onboarding_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: AppRoute.splashScreen,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoute.updateProfile:
                return MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: const UpdateProfile(),
                  ),
                );
              case AppRoute.splashScreen:
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              case AppRoute.onboarding:
                return MaterialPageRoute(
                    builder: (_) => const OnBoardingScreen());
              case AppRoute.loginScreen:
                return MaterialPageRoute(builder: (_) => const LoginScreen());
              case AppRoute.registerScreen:
                return MaterialPageRoute(
                    builder: (_) => const RegisterScreen());
              case AppRoute.homeScreen:
                return MaterialPageRoute(builder: (_) => const HomeScreen());
              case AppRoute.homeTab:
                return MaterialPageRoute(builder: (_) => const HomeTab());
              case AppRoute.searchTab:
                return MaterialPageRoute(builder: (_) => const SearchTab());
              case AppRoute.browseTab:
                return MaterialPageRoute(builder: (_) => const BrowseTab());
              case AppRoute.profileTab:
                return MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: const ProfileTab(),
                  ),
                );
              case AppRoute.forgetPassword:
                return MaterialPageRoute(
                    builder: (_) => const ForgetPassword());
              case AppRoute.movieDetailsScreen:
                final movieId = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movieId: movieId),
                );
              case AppRoute.seeMoreScreen:
                final args = settings.arguments as Map;
                return MaterialPageRoute(
                  builder: (_) => SeeMoreScreen(
                    title: args["title"] as String,
                    movies: args["movies"] as List<Movies>,
                  ),
                );
              default:
                return MaterialPageRoute(builder: (_) => const SplashScreen());
            }
          },
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
