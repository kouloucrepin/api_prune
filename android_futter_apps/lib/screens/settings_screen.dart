import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:prune_classifier/providers/locale_provider.dart';
import 'package:prune_classifier/providers/theme_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../generated/l10n.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = true;

  String selectedLanguage = 'Français';

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Tu peux ensuite utiliser un Provider ou SharedPreferences pour gérer le thème globalement
  }

  void _shareApp() {
    Share.share(
      "Télécharge cette application d'analyse des prunes en cliquant ici : https://api-prune.onrender.com/ui",
      subject: 'Prune Classifier - JCIA Hackathon',
    );
  }

  void _showQRCodeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Scanner pour télécharger"),
        content: SizedBox(
          height: 220,
          width: 220,
          child: Center(
            child: QrImageView(
              data: 'https://api-prune.onrender.com/ui',
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final lang = localeProvider.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings_title),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(S.of(context).dark_mode),
            value: isDark,
            onChanged: themeProvider.toggleTheme,
            secondary: const Icon(Icons.brightness_6),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text("Language"),
            trailing: DropdownButton<String>(
              value: lang,
              items: const [
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (langCode) {
                if (langCode != null) {
                  localeProvider.toggleLanguage(langCode);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(S.of(context).share_app),
            onTap: _shareApp,
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: Text(S.of(context).share_qr),
            onTap: _showQRCodeDialog,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(S.of(context).about_app),
            subtitle: Text(S.of(context).about_app_plus),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text(S.of(context).app_version),
            subtitle: Text("v1.0.0"),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              S.of(context).footer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ).animate().fade(duration: 1200.ms).slide(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
