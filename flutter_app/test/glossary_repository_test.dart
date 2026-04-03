import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_app/features/glossary/glossary_repository.dart';

void main() {
  test('fetchGlossary returns entries from getGlossary JSON', () async {
    final client = MockClient(
      (request) async => http.Response(
        '{"version":1,"entries":[{"id":"a","swedish":"S","english":"E","imageUrl":null}]}',
        200,
        headers: {'content-type': 'application/json'},
      ),
    );
    final repo = GlossaryRepository(httpClient: client);
    final list = await repo.fetchGlossary();
    expect(list.length, 1);
    expect(list.first.id, 'a');
    expect(list.first.swedish, 'S');
    expect(list.first.english, 'E');
  });
}
