// Live project: academy-for-nordic-skating (project number 1015388215621).
//
// You still need your Web app credentials from Firebase (FlutterFire can fill
// these automatically — see specs/001-pwa-term-glossary/quickstart.md):
//
// 1. Open https://console.firebase.google.com → project "academy-for-nordic-skating"
// 2. Gear icon → Project settings → "Your apps" → select the Web app (</>)
//    or "Add app" → Web if you have none.
// 3. Under "SDK setup and configuration", copy `apiKey` and `appId` from the
//    `firebaseConfig` object and paste them below (replace the placeholders).
//
// If Storage fails later, check Project settings → General for the default
// Storage bucket name and update [storageBucket] if it is not *.appspot.com.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default [FirebaseOptions] for use with Firebase initialization.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCQNqX9B7m_WL0RtChZat6ZC57yJC1p6Y8',
    appId: '1:1015388215621:web:c74bc9e870dfd897f9862c',
    messagingSenderId: '1015388215621',
    projectId: 'academy-for-nordic-skating',
    authDomain: 'academy-for-nordic-skating.firebaseapp.com',
    storageBucket: 'academy-for-nordic-skating.firebasestorage.app',
    measurementId: 'G-KR36KTPGPV',
  );

}