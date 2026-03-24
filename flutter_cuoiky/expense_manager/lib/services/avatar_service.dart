import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarService {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String?> uploadAvatar(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final ref = _storage.ref().child("avatars/${user.uid}.jpg");
    await ref.putFile(imageFile);

    final imageUrl = await ref.getDownloadURL();

    await _firestore.collection("users").doc(user.uid).update({
      "avatar": imageUrl,
    });

    return imageUrl;
  }

  Future<String?> getAvatarUrl() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.data()?["avatar"];
  }
}
