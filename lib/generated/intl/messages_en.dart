// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(statusCode) => "❌ API error (${statusCode})";

  static String m1(prediction) => "Result: ${prediction}";

  static String m2(error) => "❗ Unexpected error: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_app": MessageLookupByLibrary.simpleMessage("About the app"),
    "about_app_plus": MessageLookupByLibrary.simpleMessage(
      "This application was designed to automatically classify plums.",
    ),
    "api_error": m0,
    "app_version": MessageLookupByLibrary.simpleMessage("App version"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelled": MessageLookupByLibrary.simpleMessage("🔁 Analysis cancelled."),
    "cat_bruised": MessageLookupByLibrary.simpleMessage("Bruised"),
    "cat_cracked": MessageLookupByLibrary.simpleMessage("Cracked"),
    "cat_good": MessageLookupByLibrary.simpleMessage("Good quality"),
    "cat_rotten": MessageLookupByLibrary.simpleMessage("Rotten"),
    "cat_spotted": MessageLookupByLibrary.simpleMessage("Spotted"),
    "cat_unripe": MessageLookupByLibrary.simpleMessage("Unripe"),
    "categories_title": MessageLookupByLibrary.simpleMessage(
      "Detected Plum Categories",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Dark mode"),
    "desc_bruised": MessageLookupByLibrary.simpleMessage(
      "Soft or darkened areas after a fall.",
    ),
    "desc_cracked": MessageLookupByLibrary.simpleMessage(
      "Shows cracks due to shock or growth.",
    ),
    "desc_good": MessageLookupByLibrary.simpleMessage(
      "Perfect plum, spotless, firm and ready to eat.",
    ),
    "desc_rotten": MessageLookupByLibrary.simpleMessage(
      "Mold or strong smell. Discard immediately.",
    ),
    "desc_spotted": MessageLookupByLibrary.simpleMessage(
      "Superficial marks. Generally still edible.",
    ),
    "desc_unripe": MessageLookupByLibrary.simpleMessage(
      "Still green and acidic. Needs time to ripen.",
    ),
    "footer": MessageLookupByLibrary.simpleMessage("JCIA Hackathon 2025"),
    "footer_event": MessageLookupByLibrary.simpleMessage(
      "🏁 JCIA Hackathon 2025",
    ),
    "footer_jcia": MessageLookupByLibrary.simpleMessage("JCIA Hackathon 2025"),
    "footer_sub": MessageLookupByLibrary.simpleMessage(
      "Project built in 24h ⏱️",
    ),
    "help_title": MessageLookupByLibrary.simpleMessage("Help & Guide"),
    "history_analyze": MessageLookupByLibrary.simpleMessage("Analysis history"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "no_analyse": MessageLookupByLibrary.simpleMessage("No analysis recorded."),
    "no_connection": MessageLookupByLibrary.simpleMessage(
      "❌ No Internet connection.",
    ),
    "photo_tips": MessageLookupByLibrary.simpleMessage(
      "📸 Tips for better photos",
    ),
    "processing_message": MessageLookupByLibrary.simpleMessage(
      "Please wait a few seconds...",
    ),
    "processing_title": MessageLookupByLibrary.simpleMessage("Processing"),
    "project_description": MessageLookupByLibrary.simpleMessage(
      "An intelligent mobile app that scans an African plum and instantly determines its condition (ripe, rotten, cracked, etc.) using a machine learning model trained and deployed online.",
    ),
    "project_title": MessageLookupByLibrary.simpleMessage(
      "🚀 Project: PlumAnalyser",
    ),
    "quick_start": MessageLookupByLibrary.simpleMessage("🚀 Quick Start"),
    "result_title": m1,
    "retry": MessageLookupByLibrary.simpleMessage("Retry analysis"),
    "retrying": MessageLookupByLibrary.simpleMessage("Retrying..."),
    "role_abena": MessageLookupByLibrary.simpleMessage(
      "Mobile development, AI integration",
    ),
    "role_banzouzi": MessageLookupByLibrary.simpleMessage(
      "Data analysis, model evaluation, writing",
    ),
    "role_henoc": MessageLookupByLibrary.simpleMessage(
      "API development, TensorFlow Specialist",
    ),
    "role_koulou": MessageLookupByLibrary.simpleMessage(
      "Model optimization, TensorFlow, Optuna, API deployment",
    ),
    "role_loufouma": MessageLookupByLibrary.simpleMessage(
      "Design, computer graphics, writing",
    ),
    "role_ngoulou": MessageLookupByLibrary.simpleMessage(
      "Engineering student, Data Scientist",
    ),
    "settings_title": MessageLookupByLibrary.simpleMessage("Settings"),
    "share_app": MessageLookupByLibrary.simpleMessage("Share the app"),
    "share_qr": MessageLookupByLibrary.simpleMessage("Share QR code"),
    "team_title": MessageLookupByLibrary.simpleMessage("👨‍💻 Team members"),
    "tech_cv_cnn": MessageLookupByLibrary.simpleMessage(
      "Computer Vision and CNN architecture",
    ),
    "tech_flutter": MessageLookupByLibrary.simpleMessage("Flutter"),
    "tech_optuna": MessageLookupByLibrary.simpleMessage("Optuna"),
    "tech_tensorflow": MessageLookupByLibrary.simpleMessage("TensorFlow"),
    "technologies_title": MessageLookupByLibrary.simpleMessage(
      "🧰 Technologies used",
    ),
    "timeout": MessageLookupByLibrary.simpleMessage(
      "⌛ Analysis took too long. Please try again.",
    ),
    "tip_1": MessageLookupByLibrary.simpleMessage(
      "📱 Launch the app: the camera opens automatically.",
    ),
    "tip_10": MessageLookupByLibrary.simpleMessage(
      "🧽 Clean the plum if dirty for better detection.",
    ),
    "tip_2": MessageLookupByLibrary.simpleMessage(
      "Place a plum well-centered in the screen.",
    ),
    "tip_3": MessageLookupByLibrary.simpleMessage("👌 Tap the capture button!"),
    "tip_4": MessageLookupByLibrary.simpleMessage(
      "📊 See the automatic analysis and prediction displayed.",
    ),
    "tip_5": MessageLookupByLibrary.simpleMessage(
      "🖼️ You can also import an image from the gallery.",
    ),
    "tip_6": MessageLookupByLibrary.simpleMessage(
      "💡 Prefer natural light to avoid glare.",
    ),
    "tip_7": MessageLookupByLibrary.simpleMessage(
      "📷 Place the plum alone and well-centered in the image.",
    ),
    "tip_8": MessageLookupByLibrary.simpleMessage(
      "✋ Stay stable or use a stand for sharper images.",
    ),
    "tip_9": MessageLookupByLibrary.simpleMessage(
      "🫐 Make sure the plum is fully visible.",
    ),
    "unexpected_error": m2,
  };
}
