import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

class StoreData {
  Future<String?> updateImageToFirebase(String email, Uint8List file) async {
    try {
      Reference ref = _firebaseStorage.ref().child("profile image/" + email);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print("Error uploading image: $error");
      // Handle the error appropriately, e.g., show a user message
      return null;
    }
  }
}
