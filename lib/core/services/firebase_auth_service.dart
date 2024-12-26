import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  late FirebaseAuth firebaseAuth;

  FirebaseAuthService({required this.firebaseAuth});

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {

      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential.user;

  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {

      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(username);
      await credential.user?.reload();

      return credential.user;

  }

  Future<void> signOut() async {
      await firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }


}
