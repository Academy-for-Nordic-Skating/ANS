import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/features/glossary/models/glossary_entry.dart';

void main() {
  test('fromJson tolerates null strings (Firestore / loose API)', () {
    final e = GlossaryEntry.fromJson({
      'id': null,
      'swedish': null,
      'english': null,
      'imageUrl': null,
    });
    expect(e.id, '');
    expect(e.swedish, '');
    expect(e.english, '');
    expect(e.imageUrl, isNull);
  });

  test('fromJson coerces non-string to string', () {
    final e = GlossaryEntry.fromJson({
      'id': 'a',
      'swedish': 'b',
      'english': 'c',
      'imageUrl': 123,
    });
    expect(e.imageUrl, '123');
  });
}
