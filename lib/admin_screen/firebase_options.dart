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
/// import 'package:firebase_core/firebase_core.dart';

// ...


/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBGj04f5A6YgKtPB8NW-2ai11q-88RuMBM',
    appId: '1:341995618858:web:fd3fa252033443e7e1f953',
    messagingSenderId: '341995618858',
    projectId: 'eatatcanteenccfos-1',
    authDomain: 'eatatcanteenccfos-1.firebaseapp.com',
    storageBucket: 'eatatcanteenccfos-1.appspot.com',
    measurementId: 'G-R5BLRZJEL3',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ4N2HRetpi3M_ugLMEhDuZYFM4UkkyMw',
    appId: '1:341995618858:ios:8e2b84ad5d3dae13e1f953',
    messagingSenderId: '341995618858',
    projectId: 'eatatcanteenccfos-1',
    storageBucket: 'eatatcanteenccfos-1.appspot.com',
    iosBundleId: 'com.example.eatAtCanteenCcfos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJ4N2HRetpi3M_ugLMEhDuZYFM4UkkyMw',
    appId: '1:341995618858:ios:8e2b84ad5d3dae13e1f953',
    messagingSenderId: '341995618858',
    projectId: 'eatatcanteenccfos-1',
    storageBucket: 'eatatcanteenccfos-1.appspot.com',
    iosBundleId: 'com.example.eatAtCanteenCcfos',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBGj04f5A6YgKtPB8NW-2ai11q-88RuMBM',
    appId: '1:341995618858:web:59b5f696c56964dee1f953',
    messagingSenderId: '341995618858',
    projectId: 'eatatcanteenccfos-1',
    authDomain: 'eatatcanteenccfos-1.firebaseapp.com',
    storageBucket: 'eatatcanteenccfos-1.appspot.com',
    measurementId: 'G-CWHZ38ZXTP',
  );
}
