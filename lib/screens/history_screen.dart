import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prune_classifier/generated/l10n.dart';
import 'dart:io';
import 'package:prune_classifier/services/history_manager.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final entries = await HistoryManager.getHistory();
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _deleteEntry(int index) async {
    _entries.removeAt(index);
    final jsonString = _entries.map((entry) => entry.toJson()).toList();
    final file = await HistoryManager.getHistoryFile();
    await file.writeAsString(jsonEncode(jsonString));
    setState(() {});
  }

  Future<void> _clearAll() async {
    await HistoryManager.clearHistory();
    setState(() {
      _entries = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).history_analyze),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _entries.isNotEmpty ? () => _clearAll() : null,
          ),
        ],
      ),
      body: _entries.isEmpty
          ? Center(
              child: Text(S.of(context).no_analyse),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(entry.imagePath),
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(entry.label,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(entry.date),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteEntry(index),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(entry.label),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.file(File(entry.imagePath)),
                              const SizedBox(height: 10),
                              ...entry.probabilities.entries.map(
                                (e) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key),
                                    Text(
                                        '${(e.value * 100).toStringAsFixed(1)}%'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text(S.of(context).close),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
