import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app.dart';
import 'firebase_web_plugins_registration_stub.dart'
    if (dart.library.html) 'firebase_web_plugins_registration.dart';
import 'features/glossary/glossary_repository.dart';
import 'firebase_emulator.dart';
import 'firebase_options.dart';
import 'firebase_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
    // Belt-and-suspenders: Firestore, Auth, Storage must use JS SDK (not Pigeon).
    ensureFirebaseWebPluginsRegistered();
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await configureFirebaseEmulatorsIfNeeded();
  } catch (e, st) {
    debugPrint('Firebase.initializeApp failed: $e');
    debugPrint('$st');
    debugPrint(
      'Run `dart pub global run flutterfire_cli:flutterfire configure` '
      'and replace lib/firebase_options.dart.',
    );
  }
  if (firebaseOptionsLookPlaceholder) {
    debugPrint(
      'WARNING: firebase_options.dart still contains placeholder values; '
      'Firebase Auth and Firestore from the app will fail until you run FlutterFire configure.',
    );
  }
  final repository = GlossaryRepository();
  runApp(AnsApp(repository: repository));
}
