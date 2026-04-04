import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

/// True after [Firebase.initializeApp] succeeded for this process.
bool get firebaseAppIsReady => Firebase.apps.isNotEmpty;

/// True when [DefaultFirebaseOptions] still looks like the repo template (not FlutterFire output).
bool get firebaseOptionsLookPlaceholder {
  const o = DefaultFirebaseOptions.web;
  return o.apiKey == 'replace-me' ||
      o.appId.contains('000000000000:web:00000000');
}

/// Human-readable text for sign-in failures (web often throws non-[FirebaseAuthException] values).
String describeAuthFailure(Object error) {
  final raw = error.toString();
  if (error is PlatformException && error.code == 'channel-error') {
    return 'Firebase Auth is using the wrong web integration (Pigeon channel). '
        'Do a hard refresh (Shift+Reload) after deploy, or rebuild with '
        '`flutter build web`. The app must register firebase_auth_web before sign-in.';
  }
  if (raw.contains('FirebaseAuthHostApi') ||
      raw.contains('pigeon') ||
      raw.contains('Pigeon')) {
    return 'Firebase Auth could not reach your project. '
        'Replace lib/firebase_options.dart with output from '
        '`dart pub global run flutterfire_cli:flutterfire configure` '
        'for the same Firebase project you deploy to, '
        'rebuild the web app, and ensure Email/Password is enabled in Firebase Authentication.';
  }
  return raw;
}
