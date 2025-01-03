import 'package:flutter/material.dart';
import 'package:rivezni/core/services/firebase_auth_service.dart';
import 'package:rivezni/shared/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService(firebaseAuth: FirebaseAuth.instance);
  User? _user;
  bool _isLoggedIn = false;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (_isLoggedIn) {
      _user = _authService.getCurrentUser();
    }

    notifyListeners();
  }

  Future<User?> login(String email, String password) async {
    try {
      final User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        _user = user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        _isLoggedIn = true;
        notifyListeners();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code);
      showToast(message: message);
      return null;
    } catch (e) {
      showToast(message: 'An unexpected error occurred');
      return null;
    }
  }

  Future<User?> register(String email, String password, String username) async {
    
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        showToast(message: 'Please fill in all fields');
        return null;
      }
    
    try {
      final User? user = await _authService.signUpWithEmailAndPassword(
          email, password, username);
      if (user != null) {
        _user = user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        _isLoggedIn = true;
        notifyListeners();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code);
      showToast(message: message);
      return null;
    } catch (e) {
      showToast(message: 'An unexpected error occurred');
      return null;
    }
  }

Future<bool> logout() async {
  try {
    await _authService.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    _user = null;
    _isLoggedIn = false;

    notifyListeners();
    return true;
  } catch (e) {
    throw Exception("Logout failed: $e");
  }
}

}

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email address is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Please enter a stronger password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Invalid Credentials';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'An error occurred: $code';
    }
  }
