import 'package:firebase_auth/firebase_auth.dart';
import 'package:rivezni/shared/widgets/toast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code);
      showToast(message: message);
      return null;
    } catch (e) {
      showToast(message: 'An unexpected error occurred');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
    String email, 
    String password, 
    String username
  ) async {
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        showToast(message: 'Please fill in all fields');
        return null;
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      await credential.user?.updateDisplayName(username);
      await credential.user?.reload();

      return credential.user;

    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code);
      showToast(message: message);
      return null;
      
    } catch (e) {
      showToast(message: 'An unexpected error occurred');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      showToast(message: 'Failed to sign out');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
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
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'An error occurred: $code';
    }
  }
}