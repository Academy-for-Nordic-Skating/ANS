import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/glossary_entry.dart';

/// Loads glossary JSON from the Cloud Function HTTP endpoint.
class GlossaryRepository {
  GlossaryRepository({http.Client? httpClient, String? baseUrl})
      : _client = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? _glossaryUrlFromEnvironment();

  final http.Client _client;
  final String _baseUrl;

  static String _glossaryUrlFromEnvironment() {
    const url = String.fromEnvironment(
      'GLOSSARY_URL',
      defaultValue:
          'http://127.0.0.1:5001/ans-glossary-local/europe-west1/getGlossary',
    );
    return url;
  }

  Future<List<GlossaryEntry>> fetchGlossary() async {
    final uri = Uri.parse(_baseUrl);
    final response = await _client.get(uri, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode != 200) {
      throw GlossaryLoadException(
        'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
    final decoded = jsonDecode(response.body);
    // Web (dart2js): nested JSON objects are often Map<dynamic, dynamic>, not Map<String, dynamic>.
    final root = _jsonObject(decoded, context: 'root');
    final raw = root['entries'];
    if (raw is! List<dynamic>) {
      throw GlossaryLoadException('Expected "entries" array');
    }
    final out = <GlossaryEntry>[];
    for (var i = 0; i < raw.length; i++) {
      final e = raw[i];
      try {
        final map = _jsonObject(e, context: 'entries[$i]');
        out.add(GlossaryEntry.fromJson(map));
      } on Object {
        continue;
      }
    }
    return out;
  }

  void dispose() {
    _client.close();
  }

  /// Normalizes JSON objects from [jsonDecode] so web builds accept nested maps.
  static Map<String, dynamic> _jsonObject(Object? value, {required String context}) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    throw GlossaryLoadException('Expected JSON object at $context');
  }
}

class GlossaryLoadException implements Exception {
  GlossaryLoadException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'GlossaryLoadException: $message';
}
