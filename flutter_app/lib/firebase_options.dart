// Generated for local development. Run `dart pub global run flutterfire_cli:flutterfire configure`
// to replace with your Firebase project credentials.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default [FirebaseOptions] for use with Firebase initialization.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'replace-me',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'ans-glossary-local',
    authDomain: 'ans-glossary-local.firebaseapp.com',
    storageBucket: 'ans-glossary-local.appspot.com',
  );
}
