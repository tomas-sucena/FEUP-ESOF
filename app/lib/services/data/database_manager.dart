import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/volunteer.dart';

class DatabaseManager {
  final FirebaseFirestore _database;
  final FirebaseStorage _storage;

  /* CONSTRUCTOR */
  DatabaseManager()
      : _database = FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance;

  /* METHODS */
  Future<Volunteer> getVolunteer(User? user) async {
    final documentSnapshot =
        await _database.collection("users").doc(user?.email).get();

    if (documentSnapshot.exists)
      return Volunteer.fromLogin(documentSnapshot.data());

    final Volunteer volunteer = Volunteer.fromGoogle(user);
    addVolunteer(volunteer);

    return volunteer;
  }

  Future<void> addVolunteer(Volunteer volunteer) async {
    _database
        .collection("users")
        .doc(volunteer.email)
        .set(volunteer.toJSON())
        .onError((e, _) => print("Error adding a new user: $e"));
  }

  Future<String> addFile(File file, String directory, {String? id}) async {
    id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child(directory).child(id);

    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> removeFile(String fileURL) async {
    _storage
        .refFromURL(fileURL)
        .delete()
        .onError((e, _) => print("Error deleting a file: $e"));
  }
}
