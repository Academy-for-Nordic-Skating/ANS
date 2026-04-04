import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Ensures Firebase JS implementations are used instead of Pigeon MethodChannel stubs.
///
/// Without this, web can still hit [MethodChannelFirebaseFirestore] / Auth / Storage
/// and fail with `Unable to establish connection on channel`.
void ensureFirebaseWebPluginsRegistered() {
  FirebaseFirestoreWeb.registerWith(webPluginRegistrar);
  FirebaseAuthWeb.registerWith(webPluginRegistrar);
  FirebaseStorageWeb.registerWith(webPluginRegistrar);
}
