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
    apiKey: 'AIzaSyD7lcOI4z7oKvlO-6qnRPWY_ok9g_1Ji1g',
    appId: '1:1063285549929:web:35eaf319cb51c570e4abf8',
    messagingSenderId: '1063285549929',
    projectId: 'gymchimp-d7f8e',
    authDomain: 'gymchimp-d7f8e.firebaseapp.com',
    storageBucket: 'gymchimp-d7f8e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGbolVklqidbX1mCqLSkOzMonmXGyyl6Q',
    appId: '1:1063285549929:android:b228ede68f78fd57e4abf8',
    messagingSenderId: '1063285549929',
    projectId: 'gymchimp-d7f8e',
    storageBucket: 'gymchimp-d7f8e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDPdR0dQxGWfHYjK_pzTA0EuEznsjO_qg',
    appId: '1:1063285549929:ios:315f3284699487e6e4abf8',
    messagingSenderId: '1063285549929',
    projectId: 'gymchimp-d7f8e',
    storageBucket: 'gymchimp-d7f8e.appspot.com',
    iosClientId:
        '1063285549929-kb281ucm7t1csubnb18fd8usq734ncnq.apps.googleusercontent.com',
    iosBundleId: 'com.example.gymchimp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDPdR0dQxGWfHYjK_pzTA0EuEznsjO_qg',
    appId: '1:1063285549929:ios:315f3284699487e6e4abf8',
    messagingSenderId: '1063285549929',
    projectId: 'gymchimp-d7f8e',
    storageBucket: 'gymchimp-d7f8e.appspot.com',
    iosClientId:
        '1063285549929-kb281ucm7t1csubnb18fd8usq734ncnq.apps.googleusercontent.com',
    iosBundleId: 'com.example.gymchimp',
  );
}
