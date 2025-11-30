import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_style.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColor.yellow),
      titleTextStyle: AppStyle.reglur16yellow,
      backgroundColor: AppColor.blackColor,
    ),
    scaffoldBackgroundColor: AppColor.blackColor,
  );
}
