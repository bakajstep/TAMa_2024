// // File generated by FlutterFire CLI.
// // ignore_for_file: type=lint
// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for ios - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.macOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for macos - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.windows:
//         return windows;
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: 'AIzaSyDBx1ZC1a5kI5d67Dlp4kGhhSND9j8Fbk8',
//     appId: '1:1090609015078:web:0ad4633758ae9afa2fb9e7',
//     messagingSenderId: '1090609015078',
//     projectId: 'thirstquest-92a03',
//     authDomain: 'thirstquest-92a03.firebaseapp.com',
//     storageBucket: 'thirstquest-92a03.firebasestorage.app',
//   );

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyAlN0mUu87YftaCXTO-4_LLp0FltC5Nr3E',
//     appId: '1:1090609015078:android:cc9194d0202e3cdc2fb9e7',
//     messagingSenderId: '1090609015078',
//     projectId: 'thirstquest-92a03',
//     storageBucket: 'thirstquest-92a03.firebasestorage.app',
//   );

//   static const FirebaseOptions windows = FirebaseOptions(
//     apiKey: 'AIzaSyDBx1ZC1a5kI5d67Dlp4kGhhSND9j8Fbk8',
//     appId: '1:1090609015078:web:71174e0c470b3e1d2fb9e7',
//     messagingSenderId: '1090609015078',
//     projectId: 'thirstquest-92a03',
//     authDomain: 'thirstquest-92a03.firebaseapp.com',
//     storageBucket: 'thirstquest-92a03.firebasestorage.app',
//   );
// }