// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(statusCode) => "❌ Erreur API (${statusCode})";

  static String m1(prediction) => "Resultat: ${prediction}";

  static String m2(error) => "❗ Erreur inattendue : ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_app": MessageLookupByLibrary.simpleMessage("À propos de l\'app"),
    "about_app_plus": MessageLookupByLibrary.simpleMessage(
      "Cette application a été conçue pour classifier automatiquement les prunes.",
    ),
    "api_error": m0,
    "app_version": MessageLookupByLibrary.simpleMessage(
      "Version de l\'application",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "cancelled": MessageLookupByLibrary.simpleMessage("🔁 Analyse annulée."),
    "cat_bruised": MessageLookupByLibrary.simpleMessage("Meurtrie"),
    "cat_cracked": MessageLookupByLibrary.simpleMessage("Fissurée"),
    "cat_good": MessageLookupByLibrary.simpleMessage("Bonne qualité"),
    "cat_rotten": MessageLookupByLibrary.simpleMessage("Pourrie"),
    "cat_spotted": MessageLookupByLibrary.simpleMessage("Tachetée"),
    "cat_unripe": MessageLookupByLibrary.simpleMessage("Non mûre"),
    "categories_title": MessageLookupByLibrary.simpleMessage(
      "Catégories de prunes détectées",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Fermer"),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Mode sombre"),
    "desc_bruised": MessageLookupByLibrary.simpleMessage(
      "Zones molles ou brunies suite à une chute.",
    ),
    "desc_cracked": MessageLookupByLibrary.simpleMessage(
      "Présente des fissures dues à un choc ou à la croissance.",
    ),
    "desc_good": MessageLookupByLibrary.simpleMessage(
      "Prune parfaite, sans tache, ferme et prête à la consommation.",
    ),
    "desc_rotten": MessageLookupByLibrary.simpleMessage(
      "Moisissures ou odeur forte. À jeter immédiatement.",
    ),
    "desc_spotted": MessageLookupByLibrary.simpleMessage(
      "Marques superficielles. Généralement encore comestible.",
    ),
    "desc_unripe": MessageLookupByLibrary.simpleMessage(
      "Encore verte et acide. Elle a besoin de temps pour mûrir.",
    ),
    "footer": MessageLookupByLibrary.simpleMessage("JCIA Hackathon 2025"),
    "footer_event": MessageLookupByLibrary.simpleMessage(
      "🏁 JCIA Hackathon 2025",
    ),
    "footer_jcia": MessageLookupByLibrary.simpleMessage("JCIA Hackathon 2025"),
    "footer_sub": MessageLookupByLibrary.simpleMessage(
      "Projet développé en 24h chrono ⏱️",
    ),
    "help_title": MessageLookupByLibrary.simpleMessage("Aide & Guide"),
    "history_analyze": MessageLookupByLibrary.simpleMessage(
      "Historique des analyses",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Langue"),
    "no_analyse": MessageLookupByLibrary.simpleMessage(
      "Aucune analyse enregistrée.",
    ),
    "no_connection": MessageLookupByLibrary.simpleMessage(
      "❌ Problème de connexion Internet.",
    ),
    "photo_tips": MessageLookupByLibrary.simpleMessage(
      "📸 Astuces pour des photos réussies",
    ),
    "processing_message": MessageLookupByLibrary.simpleMessage(
      "Veuillez patienter quelques instants...",
    ),
    "processing_title": MessageLookupByLibrary.simpleMessage(
      "Analyse en cours",
    ),
    "project_description": MessageLookupByLibrary.simpleMessage(
      "Une application mobile intelligente qui permet de scanner une prune africaine et de déterminer instantanément son état (mûre, pourrie, fissurée, etc.) à l\'aide d\'un modèle de machine learning entraîné et déployé en ligne.",
    ),
    "project_title": MessageLookupByLibrary.simpleMessage(
      "🚀 Projet : PlumAnalyser",
    ),
    "quick_start": MessageLookupByLibrary.simpleMessage("🚀 Démarrage rapide"),
    "result_title": m1,
    "retry": MessageLookupByLibrary.simpleMessage("Relancer l\'analyse"),
    "retrying": MessageLookupByLibrary.simpleMessage("Nouvelle tentative..."),
    "role_abena": MessageLookupByLibrary.simpleMessage(
      "Développement mobile, Intégration IA",
    ),
    "role_banzouzi": MessageLookupByLibrary.simpleMessage(
      "Analyse de données, évaluation du modèle, rédaction",
    ),
    "role_henoc": MessageLookupByLibrary.simpleMessage(
      "Développement d’API, TensorFlow Specialist",
    ),
    "role_koulou": MessageLookupByLibrary.simpleMessage(
      "Optimisation du modèle, TensorFlow, Optuna, déploiement API",
    ),
    "role_loufouma": MessageLookupByLibrary.simpleMessage(
      "Design, infographie, rédaction",
    ),
    "role_ngoulou": MessageLookupByLibrary.simpleMessage(
      "Élève ingénieur, Data Scientist",
    ),
    "settings_title": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "share_app": MessageLookupByLibrary.simpleMessage(
      "Partager l\'application",
    ),
    "share_qr": MessageLookupByLibrary.simpleMessage("Partager le QR code"),
    "team_title": MessageLookupByLibrary.simpleMessage(
      "👨‍💻 Membres de l\'équipe",
    ),
    "tech_cv_cnn": MessageLookupByLibrary.simpleMessage(
      "Vision par ordinateur et architecture CNN",
    ),
    "tech_flutter": MessageLookupByLibrary.simpleMessage("Flutter"),
    "tech_optuna": MessageLookupByLibrary.simpleMessage("Optuna"),
    "tech_tensorflow": MessageLookupByLibrary.simpleMessage("TensorFlow"),
    "technologies_title": MessageLookupByLibrary.simpleMessage(
      "🧰 Technologies utilisées",
    ),
    "timeout": MessageLookupByLibrary.simpleMessage(
      "⌛ Analyse trop longue. Réessaye.",
    ),
    "tip_1": MessageLookupByLibrary.simpleMessage(
      "📱 Lancez l\'application : la caméra s’ouvre automatiquement.",
    ),
    "tip_10": MessageLookupByLibrary.simpleMessage(
      "🧽 Nettoyez la prune si elle est sale pour une meilleure détection.",
    ),
    "tip_2": MessageLookupByLibrary.simpleMessage(
      "Placez une prune bien au centre de l’écran.",
    ),
    "tip_3": MessageLookupByLibrary.simpleMessage(
      "👌 Cliquez sur le bouton de capture !",
    ),
    "tip_4": MessageLookupByLibrary.simpleMessage(
      "📊 Observez l’analyse automatique et la prédiction qui s\'affiche.",
    ),
    "tip_5": MessageLookupByLibrary.simpleMessage(
      "🖼️ Vous pouvez aussi importer une image depuis la galerie.",
    ),
    "tip_6": MessageLookupByLibrary.simpleMessage(
      "💡 Préférez la lumière naturelle pour éviter les reflets.",
    ),
    "tip_7": MessageLookupByLibrary.simpleMessage(
      "📷 Placez la prune seule et bien centrée dans l\'image.",
    ),
    "tip_8": MessageLookupByLibrary.simpleMessage(
      "✋ Restez stable ou utilisez un support pour plus de netteté.",
    ),
    "tip_9": MessageLookupByLibrary.simpleMessage(
      "🫐 Assurez-vous que la prune est bien visible et entière.",
    ),
    "unexpected_error": m2,
  };
}
