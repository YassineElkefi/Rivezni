import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rivezni/core/services/firebase_auth_service.dart';

import 'firebase_auth_service_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, FirebaseAuthException])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FirebaseAuthService underTest;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    underTest = FirebaseAuthService(firebaseAuth: mockFirebaseAuth);
  });

  test("Sign Up: Invalid Email", () async {
    String mockEmail = "hibagmail.com";
    String mockPassword = "password";
    String mockUsername = "hiba";

    final mockException = FirebaseAuthException(
      code: "invalid-email",
      message: "Invalid email address",
    );

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: mockEmail,
      password: mockPassword,
    )).thenThrow(mockException);

    expect(
      () => underTest.signUpWithEmailAndPassword(
          mockEmail, mockPassword, mockUsername),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'weak-password')),
    );
  });

  test("Sign Up: Existing Email", () async {
    String mockEmail = "hibabahri@gmail.com";
    String mockPassword = "password";
    String mockUsername = "hiba";

    final mockException = FirebaseAuthException(
      code: "email-already-in-use",
      message: "This email address is already registered",
    );

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: mockEmail,
      password: mockPassword,
    )).thenThrow(mockException);

    expect(
      () => underTest.signUpWithEmailAndPassword(
          mockEmail, mockPassword, mockUsername),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'email-already-in-use')),
    );
  });

  test("Sign In: Wrong Password", () async {
    String mockEmail = "hibabahri@gmail.com";
    String mockPassword = "password";

    final mockException = FirebaseAuthException(
      code: "wrong-password",
      message: "Invalid Credentials",
    );

    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: mockEmail,
      password: mockPassword,
    )).thenThrow(mockException);

    expect(
      () => underTest.signInWithEmailAndPassword(mockEmail, mockPassword),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'wrong-password')),
    );
  });

    test("Sign In: No Accunt Found With This Email", () async {
    String mockEmail = "hibabahri@gmail.com";
    String mockPassword = "password";

    final mockException = FirebaseAuthException(
      code: "user-not-found",
      message: "No account found with this email",
    );

    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: mockEmail,
      password: mockPassword,
    )).thenThrow(mockException);

    expect(
      () => underTest.signInWithEmailAndPassword(mockEmail, mockPassword),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'user-not-found')),
    );
  });
}
