import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Error during sign up: $e');
    }
  }
}
