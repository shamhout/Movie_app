import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/locale/localization.dart';
import 'package:movie_app/utils/app_color.dart';

class LanguageToggle extends StatelessWidget {
  final Function(String)? onChangedLanguage;

  const LanguageToggle({super.key, this.onChangedLanguage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final int selectedValue = locale.languageCode == 'en' ? 0 : 1;
        return AnimatedToggleSwitch<int>.rolling(
          iconOpacity: 1.0,
          allowUnlistedValues: true,
          current: selectedValue,
          spacing: 15,
          values: const [0, 1],
          onChanged: (value) async {
            final String languageCode = value == 0 ? 'en' : 'ar';
            await context.read<LocaleCubit>().changeLocale(languageCode);
            onChangedLanguage?.call(languageCode);
          },
          iconBuilder: (value, foreground) => Center(
            child: _flagByValue(value),
          ),
          style: ToggleStyle(
            backgroundColor: Colors.transparent,
            borderColor: AppColor.yellow,
            borderRadius: BorderRadius.circular(25),
            indicatorColor: AppColor.yellow,
          ),
          borderWidth: 1.5,
        );
      },
    );
  }

  Widget _flagByValue(int? value) {
    switch (value) {
      case 0:
        return Flag.fromCode(FlagsCode.US, height: 20, width: 30);
      case 1:
        return Flag.fromCode(FlagsCode.EG, height: 20, width: 30);
      default:
        return const Icon(Icons.language, size: 20, color: Colors.white);
    }
  }
}
