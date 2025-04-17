import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class HistoryEntry {
  final String label;
  final String imagePath;
  final String date;
  final Map<String, double> probabilities;

  HistoryEntry({
    required this.label,
    required this.imagePath,
    required this.date,
    required this.probabilities,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'imagePath': imagePath,
        'date': date,
        'probabilities': probabilities,
      };

  static HistoryEntry fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      label: json['label'],
      imagePath: json['imagePath'],
      date: json['date'],
      probabilities: Map<String, double>.from(json['probabilities']),
    );
  }
}

class HistoryManager {
  static Future<File> getHistoryFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/prediction_history.json');
  }

  static Future<void> saveEntry(HistoryEntry entry) async {
    final file = await getHistoryFile();
    List<HistoryEntry> history = await getHistory();
    history.insert(0, entry); // Dernier d'abord
    final jsonString = jsonEncode(history.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  static Future<List<HistoryEntry>> getHistory() async {
    try {
      final file = await getHistoryFile();
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((json) => HistoryEntry.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearHistory() async {
    final file = await getHistoryFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<String> saveImageLocally(File imageFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'prune_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newPath = '${dir.path}/$filename';
    final newFile = await imageFile.copy(newPath);
    return newFile.path;
  }

  static String formattedDateNow() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }
}
