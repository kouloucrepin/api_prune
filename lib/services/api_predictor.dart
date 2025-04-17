import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:prune_classifier/generated/l10n.dart';

Future<dynamic> predictFromAPI(
  File imageFile, {
  required BuildContext context,
  Duration timeout = const Duration(seconds: 60),
  required bool Function() cancelled,
}) async {
  final s = S.of(context);
  final uri = Uri.parse("https://api-prune.onrender.com/predict/");

  try {
    // 🧊 Étape 1 — Préchauffer l’API (GET)
    await http.get(Uri.parse("https://api-prune.onrender.com/")).timeout(
          const Duration(seconds: 5),
          onTimeout: () => http.Response('Warmup Timeout', 200),
        );

    // Fonction d'envoi
    Future<http.StreamedResponse> sendRequest() async {
      final bytes = await imageFile.readAsBytes();
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);
      final request = http.MultipartRequest("POST", uri);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: basename(imageFile.path),
        contentType: mediaType,
      ));
      return request.send().timeout(timeout);
    }

    http.StreamedResponse response;

    try {
      response = await sendRequest();
    } on TimeoutException {
      if (cancelled()) return s.cancelled;

      // 🔁 RETRY après timeout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⏳ ${s.timeout} — ${s.retrying}"),
          backgroundColor: Colors.deepPurple,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      response = await sendRequest(); // retry
    }

    if (cancelled()) return s.cancelled;

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final json = jsonDecode(responseBody);

      final label = json['predicted_class_fr'] ?? "Inconnu";
      final confidence = (json['confidence'] as num).toDouble();
      final probs = (json['probabilities'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      );

      return {
        'label': "$label (${(confidence * 100).toStringAsFixed(1)}%)",
        'probabilities': probs,
      };
    } else {
      return s.api_error(response.statusCode.toString());
    }
  } on SocketException {
    return s.no_connection;
  } on TimeoutException {
    return s.timeout;
  } catch (e) {
    return s.unexpected_error(e.toString());
  }
}
