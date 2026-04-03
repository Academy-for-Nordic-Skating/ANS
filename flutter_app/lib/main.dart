import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'features/glossary/glossary_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase.initializeApp failed: $e');
    debugPrint('$st');
    debugPrint(
      'Run `dart pub global run flutterfire_cli:flutterfire configure` '
      'and replace lib/firebase_options.dart.',
    );
  }
  final repository = GlossaryRepository();
  runApp(AnsApp(repository: repository));
}
