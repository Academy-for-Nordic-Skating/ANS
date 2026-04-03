/// One glossary row from the HTTP API ([contracts/glossary-api.openapi.yaml]).
class GlossaryEntry {
  const GlossaryEntry({
    required this.id,
    required this.swedish,
    required this.english,
    required this.imageUrl,
  });

  final String id;
  final String swedish;
  final String english;
  final String? imageUrl;

  /// Parses API / JSON maps from Firestore-backed Functions.
  /// Coerces null or non-string values so web/minified builds do not throw.
  factory GlossaryEntry.fromJson(Map<String, dynamic> json) {
    return GlossaryEntry(
      id: _reqString(json, 'id'),
      swedish: _reqString(json, 'swedish'),
      english: _reqString(json, 'english'),
      imageUrl: _optString(json, 'imageUrl'),
    );
  }

  static String _reqString(Map<String, dynamic> json, String key) {
    final Object? v = json[key];
    if (v == null) {
      return '';
    }
    if (v is String) {
      return v;
    }
    return v.toString();
  }

  static String? _optString(Map<String, dynamic> json, String key) {
    final Object? v = json[key];
    if (v == null) {
      return null;
    }
    if (v is String) {
      return v.isEmpty ? null : v;
    }
    final s = v.toString();
    return s.isEmpty ? null : s;
  }
}
