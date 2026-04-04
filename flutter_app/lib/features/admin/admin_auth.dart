import 'package:cloud_firestore/cloud_firestore.dart';

/// Returns true if [users]/{uid} grants admin via `role == 'admin'` or `isAdmin == true`.
Future<bool> userIsAdmin(String uid) async {
  final snap =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!snap.exists) {
    return false;
  }
  final data = snap.data();
  if (data == null) {
    return false;
  }
  if (data['role'] == 'admin') {
    return true;
  }
  if (data['isAdmin'] == true) {
    return true;
  }
  return false;
}
