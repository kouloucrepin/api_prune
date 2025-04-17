// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settings_title {
    return Intl.message('Settings', name: 'settings_title', desc: '', args: []);
  }

  /// `Dark mode`
  String get dark_mode {
    return Intl.message('Dark mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Share the app`
  String get share_app {
    return Intl.message('Share the app', name: 'share_app', desc: '', args: []);
  }

  /// `Share QR code`
  String get share_qr {
    return Intl.message('Share QR code', name: 'share_qr', desc: '', args: []);
  }

  /// `About the app`
  String get about_app {
    return Intl.message('About the app', name: 'about_app', desc: '', args: []);
  }

  /// `App version`
  String get app_version {
    return Intl.message('App version', name: 'app_version', desc: '', args: []);
  }

  /// `JCIA Hackathon 2025`
  String get footer {
    return Intl.message(
      'JCIA Hackathon 2025',
      name: 'footer',
      desc: '',
      args: [],
    );
  }

  /// `This application was designed to automatically classify plums.`
  String get about_app_plus {
    return Intl.message(
      'This application was designed to automatically classify plums.',
      name: 'about_app_plus',
      desc: '',
      args: [],
    );
  }

  /// `Analysis history`
  String get history_analyze {
    return Intl.message(
      'Analysis history',
      name: 'history_analyze',
      desc: '',
      args: [],
    );
  }

  /// `No analysis recorded.`
  String get no_analyse {
    return Intl.message(
      'No analysis recorded.',
      name: 'no_analyse',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Help & Guide`
  String get help_title {
    return Intl.message('Help & Guide', name: 'help_title', desc: '', args: []);
  }

  /// `🚀 Quick Start`
  String get quick_start {
    return Intl.message(
      '🚀 Quick Start',
      name: 'quick_start',
      desc: '',
      args: [],
    );
  }

  /// `📱 Launch the app: the camera opens automatically.`
  String get tip_1 {
    return Intl.message(
      '📱 Launch the app: the camera opens automatically.',
      name: 'tip_1',
      desc: '',
      args: [],
    );
  }

  /// `Place a plum well-centered in the screen.`
  String get tip_2 {
    return Intl.message(
      'Place a plum well-centered in the screen.',
      name: 'tip_2',
      desc: '',
      args: [],
    );
  }

  /// `👌 Tap the capture button!`
  String get tip_3 {
    return Intl.message(
      '👌 Tap the capture button!',
      name: 'tip_3',
      desc: '',
      args: [],
    );
  }

  /// `📊 See the automatic analysis and prediction displayed.`
  String get tip_4 {
    return Intl.message(
      '📊 See the automatic analysis and prediction displayed.',
      name: 'tip_4',
      desc: '',
      args: [],
    );
  }

  /// `🖼️ You can also import an image from the gallery.`
  String get tip_5 {
    return Intl.message(
      '🖼️ You can also import an image from the gallery.',
      name: 'tip_5',
      desc: '',
      args: [],
    );
  }

  /// `📸 Tips for better photos`
  String get photo_tips {
    return Intl.message(
      '📸 Tips for better photos',
      name: 'photo_tips',
      desc: '',
      args: [],
    );
  }

  /// `💡 Prefer natural light to avoid glare.`
  String get tip_6 {
    return Intl.message(
      '💡 Prefer natural light to avoid glare.',
      name: 'tip_6',
      desc: '',
      args: [],
    );
  }

  /// `📷 Place the plum alone and well-centered in the image.`
  String get tip_7 {
    return Intl.message(
      '📷 Place the plum alone and well-centered in the image.',
      name: 'tip_7',
      desc: '',
      args: [],
    );
  }

  /// `✋ Stay stable or use a stand for sharper images.`
  String get tip_8 {
    return Intl.message(
      '✋ Stay stable or use a stand for sharper images.',
      name: 'tip_8',
      desc: '',
      args: [],
    );
  }

  /// `🫐 Make sure the plum is fully visible.`
  String get tip_9 {
    return Intl.message(
      '🫐 Make sure the plum is fully visible.',
      name: 'tip_9',
      desc: '',
      args: [],
    );
  }

  /// `🧽 Clean the plum if dirty for better detection.`
  String get tip_10 {
    return Intl.message(
      '🧽 Clean the plum if dirty for better detection.',
      name: 'tip_10',
      desc: '',
      args: [],
    );
  }

  /// `Detected Plum Categories`
  String get categories_title {
    return Intl.message(
      'Detected Plum Categories',
      name: 'categories_title',
      desc: '',
      args: [],
    );
  }

  /// `Good quality`
  String get cat_good {
    return Intl.message('Good quality', name: 'cat_good', desc: '', args: []);
  }

  /// `Perfect plum, spotless, firm and ready to eat.`
  String get desc_good {
    return Intl.message(
      'Perfect plum, spotless, firm and ready to eat.',
      name: 'desc_good',
      desc: '',
      args: [],
    );
  }

  /// `Unripe`
  String get cat_unripe {
    return Intl.message('Unripe', name: 'cat_unripe', desc: '', args: []);
  }

  /// `Still green and acidic. Needs time to ripen.`
  String get desc_unripe {
    return Intl.message(
      'Still green and acidic. Needs time to ripen.',
      name: 'desc_unripe',
      desc: '',
      args: [],
    );
  }

  /// `Spotted`
  String get cat_spotted {
    return Intl.message('Spotted', name: 'cat_spotted', desc: '', args: []);
  }

  /// `Superficial marks. Generally still edible.`
  String get desc_spotted {
    return Intl.message(
      'Superficial marks. Generally still edible.',
      name: 'desc_spotted',
      desc: '',
      args: [],
    );
  }

  /// `Cracked`
  String get cat_cracked {
    return Intl.message('Cracked', name: 'cat_cracked', desc: '', args: []);
  }

  /// `Shows cracks due to shock or growth.`
  String get desc_cracked {
    return Intl.message(
      'Shows cracks due to shock or growth.',
      name: 'desc_cracked',
      desc: '',
      args: [],
    );
  }

  /// `Bruised`
  String get cat_bruised {
    return Intl.message('Bruised', name: 'cat_bruised', desc: '', args: []);
  }

  /// `Soft or darkened areas after a fall.`
  String get desc_bruised {
    return Intl.message(
      'Soft or darkened areas after a fall.',
      name: 'desc_bruised',
      desc: '',
      args: [],
    );
  }

  /// `Rotten`
  String get cat_rotten {
    return Intl.message('Rotten', name: 'cat_rotten', desc: '', args: []);
  }

  /// `Mold or strong smell. Discard immediately.`
  String get desc_rotten {
    return Intl.message(
      'Mold or strong smell. Discard immediately.',
      name: 'desc_rotten',
      desc: '',
      args: [],
    );
  }

  /// `JCIA Hackathon 2025`
  String get footer_jcia {
    return Intl.message(
      'JCIA Hackathon 2025',
      name: 'footer_jcia',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing_title {
    return Intl.message(
      'Processing',
      name: 'processing_title',
      desc: '',
      args: [],
    );
  }

  /// `Please wait a few seconds...`
  String get processing_message {
    return Intl.message(
      'Please wait a few seconds...',
      name: 'processing_message',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Retry analysis`
  String get retry {
    return Intl.message('Retry analysis', name: 'retry', desc: '', args: []);
  }

  /// `Result: {prediction}`
  String result_title(Object prediction) {
    return Intl.message(
      'Result: $prediction',
      name: 'result_title',
      desc: '',
      args: [prediction],
    );
  }

  /// `🔁 Analysis cancelled.`
  String get cancelled {
    return Intl.message(
      '🔁 Analysis cancelled.',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `❌ API error ({statusCode})`
  String api_error(Object statusCode) {
    return Intl.message(
      '❌ API error ($statusCode)',
      name: 'api_error',
      desc: '',
      args: [statusCode],
    );
  }

  /// `❌ No Internet connection.`
  String get no_connection {
    return Intl.message(
      '❌ No Internet connection.',
      name: 'no_connection',
      desc: '',
      args: [],
    );
  }

  /// `⌛ Analysis took too long. Please try again.`
  String get timeout {
    return Intl.message(
      '⌛ Analysis took too long. Please try again.',
      name: 'timeout',
      desc: '',
      args: [],
    );
  }

  /// `❗ Unexpected error: {error}`
  String unexpected_error(Object error) {
    return Intl.message(
      '❗ Unexpected error: $error',
      name: 'unexpected_error',
      desc: '',
      args: [error],
    );
  }

  /// `🚀 Project: PlumAnalyser`
  String get project_title {
    return Intl.message(
      '🚀 Project: PlumAnalyser',
      name: 'project_title',
      desc: '',
      args: [],
    );
  }

  /// `An intelligent mobile app that scans an African plum and instantly determines its condition (ripe, rotten, cracked, etc.) using a machine learning model trained and deployed online.`
  String get project_description {
    return Intl.message(
      'An intelligent mobile app that scans an African plum and instantly determines its condition (ripe, rotten, cracked, etc.) using a machine learning model trained and deployed online.',
      name: 'project_description',
      desc: '',
      args: [],
    );
  }

  /// `🧰 Technologies used`
  String get technologies_title {
    return Intl.message(
      '🧰 Technologies used',
      name: 'technologies_title',
      desc: '',
      args: [],
    );
  }

  /// `Flutter`
  String get tech_flutter {
    return Intl.message('Flutter', name: 'tech_flutter', desc: '', args: []);
  }

  /// `Computer Vision and CNN architecture`
  String get tech_cv_cnn {
    return Intl.message(
      'Computer Vision and CNN architecture',
      name: 'tech_cv_cnn',
      desc: '',
      args: [],
    );
  }

  /// `TensorFlow`
  String get tech_tensorflow {
    return Intl.message(
      'TensorFlow',
      name: 'tech_tensorflow',
      desc: '',
      args: [],
    );
  }

  /// `Optuna`
  String get tech_optuna {
    return Intl.message('Optuna', name: 'tech_optuna', desc: '', args: []);
  }

  /// `👨‍💻 Team members`
  String get team_title {
    return Intl.message(
      '👨‍💻 Team members',
      name: 'team_title',
      desc: '',
      args: [],
    );
  }

  /// `🏁 JCIA Hackathon 2025`
  String get footer_event {
    return Intl.message(
      '🏁 JCIA Hackathon 2025',
      name: 'footer_event',
      desc: '',
      args: [],
    );
  }

  /// `Project built in 24h ⏱️`
  String get footer_sub {
    return Intl.message(
      'Project built in 24h ⏱️',
      name: 'footer_sub',
      desc: '',
      args: [],
    );
  }

  /// `Data analysis, model evaluation, writing`
  String get role_banzouzi {
    return Intl.message(
      'Data analysis, model evaluation, writing',
      name: 'role_banzouzi',
      desc: '',
      args: [],
    );
  }

  /// `Model optimization, TensorFlow, Optuna, API deployment`
  String get role_koulou {
    return Intl.message(
      'Model optimization, TensorFlow, Optuna, API deployment',
      name: 'role_koulou',
      desc: '',
      args: [],
    );
  }

  /// `Mobile development, AI integration`
  String get role_abena {
    return Intl.message(
      'Mobile development, AI integration',
      name: 'role_abena',
      desc: '',
      args: [],
    );
  }

  /// `Design, computer graphics, writing`
  String get role_loufouma {
    return Intl.message(
      'Design, computer graphics, writing',
      name: 'role_loufouma',
      desc: '',
      args: [],
    );
  }

  /// `API development, TensorFlow Specialist`
  String get role_henoc {
    return Intl.message(
      'API development, TensorFlow Specialist',
      name: 'role_henoc',
      desc: '',
      args: [],
    );
  }

  /// `Engineering student, Data Scientist`
  String get role_ngoulou {
    return Intl.message(
      'Engineering student, Data Scientist',
      name: 'role_ngoulou',
      desc: '',
      args: [],
    );
  }

  /// `Retrying...`
  String get retrying {
    return Intl.message('Retrying...', name: 'retrying', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
