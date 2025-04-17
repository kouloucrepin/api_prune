import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prune_classifier/generated/l10n.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(s.help_title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(s.quick_start),
            const SizedBox(height: 12),
            _horizontalCardList([
              s.tip_1,
              s.tip_2,
              s.tip_3,
              s.tip_4,
              s.tip_5,
            ], isDark),
            const SizedBox(height: 30),
            _sectionTitle(s.photo_tips),
            const SizedBox(height: 12),
            _horizontalCardList([
              s.tip_6,
              s.tip_7,
              s.tip_8,
              s.tip_9,
              s.tip_10,
            ], isDark),
            const SizedBox(height: 30),
            _sectionTitle(s.categories_title),
            const SizedBox(height: 12),
            _categoryCard(s.cat_good, s.desc_good, Icons.check_circle,
                Colors.green.shade600, isDark),
            _categoryCard(s.cat_unripe, s.desc_unripe, Icons.eco,
                Colors.teal.shade600, isDark),
            _categoryCard(s.cat_spotted, s.desc_spotted, Icons.blur_on,
                Colors.orange.shade600, isDark),
            _categoryCard(s.cat_cracked, s.desc_cracked, Icons.grain,
                Colors.brown.shade400, isDark),
            _categoryCard(s.cat_bruised, s.desc_bruised, Icons.warning_amber,
                Colors.deepOrange.shade400, isDark),
            _categoryCard(s.cat_rotten, s.desc_rotten, Icons.cancel,
                Colors.red.shade600, isDark),
            const SizedBox(height: 40),
            Center(
              child: Text(
                s.footer_jcia,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ).animate().fade(duration: 1200.ms).slide(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    ).animate().fade(duration: 600.ms).slideY(begin: 0.2);
  }

  static Widget _horizontalCardList(List<String> tips, bool isDark) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: isDark ? Colors.grey.shade900 : Colors.deepPurple.shade50,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    tips[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ).animate().fade(duration: 500.ms).slideX(begin: 0.3),
          );
        },
      ),
    );
  }

  static Widget _categoryCard(String title, String description, IconData icon,
      Color iconColor, bool isDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: isDark ? Colors.grey.shade300 : Colors.black54,
            fontSize: 15,
          ),
        ),
      ).animate().fade(duration: 500.ms).slideX(begin: 0.3),
    );
  }
}
