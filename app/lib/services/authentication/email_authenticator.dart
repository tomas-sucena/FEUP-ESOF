import 'package:app/services/data/database_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/volunteer.dart';
import 'authenticator.dart';

class EmailAuthenticator extends Authenticator {
  final String _email;
  final String _password;
  final String _repeatedPassword;
  final String _name;
  final String _phoneNumber;

  /* CONSTRUCTOR */
  EmailAuthenticator(
      {required String email,
      required String password,
      String? repeatedPassword,
      String? name,
      String? phoneNumber})
      : _email = email,
        _password = password,
        _repeatedPassword = repeatedPassword ?? '',
        _name = name ?? '',
        _phoneNumber = phoneNumber ?? '';

  /* METHODS */
  @override
  Future<String> signIn() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "Invalid email!";
        case "user-not-found":
          return "There is no user with that email!";
        case "wrong-password":
          return "Incorrect password!";
        default:
          return "Error signing in!";
      }
    }

    return "success";
  }

  Future<String> register() async {
    if (_password != _repeatedPassword) return "The passwords do not match!";

    if (_name.length > 18) return "Name is too long!";

    try {
      await auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "The email provided is already being used!";
        case "invalid-email":
          return "Invalid email!";
        case "weak-password":
          return "The password provided is too weak!";
        default:
          return "Network error!";
      }
    }

    // update the database
    User? user = auth.currentUser;
    if (user == null) return "Authentication error! Please, try again.";

    await DatabaseManager().addVolunteer(
      Volunteer.fromJSON({
        "id": user.uid,
        "name": _name,
        "email": _email,
        "phoneNumber": _phoneNumber,
      }),
    );

    return "success";
  }
}
