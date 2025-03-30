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
    apiKey: 'AIzaSyCYY4UyP4zZ7NpK7Dx-uQ7ob9Yp8I-4FxQ',
    appId: '1:672514452819:web:b5588287168b58882145a6',
    messagingSenderId: '672514452819',
    projectId: 'droneworkz-facc9',
    authDomain: 'droneworkz-facc9.firebaseapp.com',
    databaseURL: 'https://droneworkz-facc9-default-rtdb.firebaseio.com',
    storageBucket: 'droneworkz-facc9.firebasestorage.app',
    measurementId: 'G-5M12E9VM1V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDdBX0xo7c7Q8dhVjQObwqTsIoJxyPyPU',
    appId: '1:672514452819:android:12046211cf9f42c42145a6',
    messagingSenderId: '672514452819',
    projectId: 'droneworkz-facc9',
    databaseURL: 'https://droneworkz-facc9-default-rtdb.firebaseio.com',
    storageBucket: 'droneworkz-facc9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkZTZ9wIaJD6zrrkKkrDZeesCkeyB4ur8',
    appId: '1:672514452819:ios:8917a517557663fe2145a6',
    messagingSenderId: '672514452819',
    projectId: 'droneworkz-facc9',
    databaseURL: 'https://droneworkz-facc9-default-rtdb.firebaseio.com',
    storageBucket: 'droneworkz-facc9.firebasestorage.app',
    iosClientId: '672514452819-msdkbmevasceda28d95oqj91359b958f.apps.googleusercontent.com',
    iosBundleId: 'com.example.droneworkz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCkZTZ9wIaJD6zrrkKkrDZeesCkeyB4ur8',
    appId: '1:672514452819:ios:8917a517557663fe2145a6',
    messagingSenderId: '672514452819',
    projectId: 'droneworkz-facc9',
    databaseURL: 'https://droneworkz-facc9-default-rtdb.firebaseio.com',
    storageBucket: 'droneworkz-facc9.firebasestorage.app',
    iosClientId: '672514452819-msdkbmevasceda28d95oqj91359b958f.apps.googleusercontent.com',
    iosBundleId: 'com.example.droneworkz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYY4UyP4zZ7NpK7Dx-uQ7ob9Yp8I-4FxQ',
    appId: '1:672514452819:web:dbd8f49997ed00362145a6',
    messagingSenderId: '672514452819',
    projectId: 'droneworkz-facc9',
    authDomain: 'droneworkz-facc9.firebaseapp.com',
    databaseURL: 'https://droneworkz-facc9-default-rtdb.firebaseio.com',
    storageBucket: 'droneworkz-facc9.firebasestorage.app',
    measurementId: 'G-2P9N5XRPKC',
  );

}