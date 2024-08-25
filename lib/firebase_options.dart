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
    apiKey: 'AIzaSyCBzMZfSOkIYud3_72vaWOcTy6q14yCeJs',
    appId: '1:503667879329:web:4408ed805fd18c0c876fe0',
    messagingSenderId: '503667879329',
    projectId: 'seewithme-efea4',
    authDomain: 'seewithme-efea4.firebaseapp.com',
    storageBucket: 'seewithme-efea4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAk4CsXjYajS2ke3HkUW3oM7Oc1uZwMjxs',
    appId: '1:503667879329:android:6d656cefe352d79c876fe0',
    messagingSenderId: '503667879329',
    projectId: 'seewithme-efea4',
    storageBucket: 'seewithme-efea4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6JfAIoz6igjjifRs25MS1VU7dhXnA72g',
    appId: '1:503667879329:ios:546a22eee32ee6e9876fe0',
    messagingSenderId: '503667879329',
    projectId: 'seewithme-efea4',
    storageBucket: 'seewithme-efea4.appspot.com',
    iosBundleId: 'com.example.seeWithMe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6JfAIoz6igjjifRs25MS1VU7dhXnA72g',
    appId: '1:503667879329:ios:546a22eee32ee6e9876fe0',
    messagingSenderId: '503667879329',
    projectId: 'seewithme-efea4',
    storageBucket: 'seewithme-efea4.appspot.com',
    iosBundleId: 'com.example.seeWithMe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBzMZfSOkIYud3_72vaWOcTy6q14yCeJs',
    appId: '1:503667879329:web:752913b0f4ff6f07876fe0',
    messagingSenderId: '503667879329',
    projectId: 'seewithme-efea4',
    authDomain: 'seewithme-efea4.firebaseapp.com',
    storageBucket: 'seewithme-efea4.appspot.com',
  );
}