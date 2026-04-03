import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_app/features/glossary/glossary_page.dart';
import 'package:flutter_app/features/glossary/glossary_repository.dart';

void main() {
  testWidgets('shows empty glossary when API returns no entries', (tester) async {
    final client = MockClient(
      (request) async => http.Response(
        '{"version":1,"updatedAt":null,"entries":[]}',
        200,
        headers: {'content-type': 'application/json'},
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: GlossaryPage(
          repository: GlossaryRepository(httpClient: client),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No terms yet'), findsOneWidget);
  });
}
