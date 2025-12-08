import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }
  static const String _localeKey = 'app_locale';

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        emit(Locale(languageCode));
      }
    } catch (e) {}
  }

  Future<void> changeLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      emit(Locale(languageCode));
    } catch (e) {}
  }

  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en' ? 'ar' : 'en';
    await changeLocale(newLocale);
  }

  String get currentLanguageCode => state.languageCode;
  bool get isArabic => state.languageCode == 'ar';
  bool get isEnglish => state.languageCode == 'en';
}
