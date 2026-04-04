import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Connects Auth, Firestore, and Storage to local emulators when built with
/// `--dart-define=USE_FIREBASE_EMULATOR=true`.
Future<void> configureFirebaseEmulatorsIfNeeded() async {
  const useEmu = bool.fromEnvironment(
    'USE_FIREBASE_EMULATOR',
    defaultValue: false,
  );
  if (!useEmu) {
    return;
  }

  FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
  await FirebaseStorage.instance.useStorageEmulator('127.0.0.1', 9199);
}
