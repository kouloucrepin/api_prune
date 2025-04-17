import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prune_classifier/generated/l10n.dart';

class AboutProjectScreen extends StatelessWidget {
  const AboutProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> team = [
      {
        "name": "BANZOUZI MIAMPASSI Hermann",
        "role": s.role_banzouzi,
        "photo": "assets/images/banzouzi_miampassi.jpg"
      },
      {
        "name": "KOULOU Anaklasse Crépin",
        "role": s.role_koulou,
        "photo": "assets/images/koulou_crepin.jpg"
      },
      {
        "name": "ABENA BALA Marc-Loïc",
        "role": s.role_abena,
        "photo": "assets/images/abena_marc.jpg"
      },
      {
        "name": "LOUFOUMA KAYA Tardi Offrande",
        "role": s.role_loufouma,
        "photo": "assets/images/loufouma_kaya.jpg"
      },
      {
        "name": "Hénoc GAKPETO",
        "role": s.role_henoc,
        "photo": "assets/images/henoc_gakpeto.jpg"
      },
      {
        "name": "NGOULOU NGOUBILI Irch Defluviaire",
        "role": s.role_ngoulou,
        "photo": "assets/images/ngoulou_ngoubili.jpg"
      }
    ];

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1e1e1e) : const Color(0xFFf5f6fa),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.project_title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                s.project_description,
                style: const TextStyle(
                    fontSize: 16, color: Colors.white, height: 1.5),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              s.technologies_title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                techChip(s.tech_flutter),
                techChip(s.tech_cv_cnn),
                techChip(s.tech_tensorflow),
                techChip(s.tech_optuna),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              s.team_title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            ...team.map((member) => teamCard(member, isDark)).toList(),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(s.footer_event,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18)),
                  const SizedBox(height: 6),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget techChip(String label) {
    final color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return Chip(
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  Widget teamCard(Map<String, String> member, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey[850] : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(member['photo']!),
        ),
        title: Text(
          member['name'] ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          member['role'] ?? '',
          style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontSize: 14),
        ),
      ),
    );
  }
}
