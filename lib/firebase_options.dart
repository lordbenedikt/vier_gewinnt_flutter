// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAI2SSNQ9-W9SC6sfRl_8t9TTtWhUkjgcw',
    appId: '1:733325436586:web:feeaa52e4f5ef4ddb652d3',
    messagingSenderId: '733325436586',
    projectId: 'fir-flutter-codelab-d2abc',
    authDomain: 'fir-flutter-codelab-d2abc.firebaseapp.com',
    storageBucket: 'fir-flutter-codelab-d2abc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdES06hpP1HpqOUTycEbLh_JH-glN2ZAY',
    appId: '1:733325436586:android:db9815042276fa53b652d3',
    messagingSenderId: '733325436586',
    projectId: 'fir-flutter-codelab-d2abc',
    storageBucket: 'fir-flutter-codelab-d2abc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwv4N4ZTRx61tmu7TdqCR5Sm0dn1sV0gY',
    appId: '1:733325436586:ios:b07b613da3147663b652d3',
    messagingSenderId: '733325436586',
    projectId: 'fir-flutter-codelab-d2abc',
    storageBucket: 'fir-flutter-codelab-d2abc.appspot.com',
    iosBundleId: 'com.example.gtkFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwv4N4ZTRx61tmu7TdqCR5Sm0dn1sV0gY',
    appId: '1:733325436586:ios:1ce5184acf5bdde9b652d3',
    messagingSenderId: '733325436586',
    projectId: 'fir-flutter-codelab-d2abc',
    storageBucket: 'fir-flutter-codelab-d2abc.appspot.com',
    iosBundleId: 'com.example.gtkFlutter.RunnerTests',
  );
}
