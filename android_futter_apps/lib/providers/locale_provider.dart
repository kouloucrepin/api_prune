import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  void toggleLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
