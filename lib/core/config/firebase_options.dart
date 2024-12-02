// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBRWtGcdL7CnRB8SPUU0x_B8Dk8H3ydmy4',
    appId: '1:1023849875791:web:74c4bd0a9f2b4d83789d3a',
    messagingSenderId: '1023849875791',
    projectId: 'rivezni',
    authDomain: 'rivezni.firebaseapp.com',
    storageBucket: 'rivezni.firebasestorage.app',
    measurementId: 'G-T9JCED2PYG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIMsPNAjeKrpj8nFKLsoPfe2oYEFmCIJE',
    appId: '1:1023849875791:android:7576ae7c1076b697789d3a',
    messagingSenderId: '1023849875791',
    projectId: 'rivezni',
    storageBucket: 'rivezni.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByhva7E8FJp9hkEh8iT6-DF7BXkUrKB5E',
    appId: '1:1023849875791:ios:fac6e4b0e66aeca2789d3a',
    messagingSenderId: '1023849875791',
    projectId: 'rivezni',
    storageBucket: 'rivezni.firebasestorage.app',
    iosBundleId: 'com.example.rivezni',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByhva7E8FJp9hkEh8iT6-DF7BXkUrKB5E',
    appId: '1:1023849875791:ios:fac6e4b0e66aeca2789d3a',
    messagingSenderId: '1023849875791',
    projectId: 'rivezni',
    storageBucket: 'rivezni.firebasestorage.app',
    iosBundleId: 'com.example.rivezni',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRWtGcdL7CnRB8SPUU0x_B8Dk8H3ydmy4',
    appId: '1:1023849875791:web:c489b129334b65dd789d3a',
    messagingSenderId: '1023849875791',
    projectId: 'rivezni',
    authDomain: 'rivezni.firebaseapp.com',
    storageBucket: 'rivezni.firebasestorage.app',
    measurementId: 'G-MEM5B8KRHM',
  );
}
