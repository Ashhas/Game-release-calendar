// File generated manually based on google-services.json and GoogleService-Info.plist
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlWwv-F3zKLYeqpqMc5WE_Ayes3SdoAIA',
    appId: '1:208744369789:android:8f7f58c8808d5c35612b14',
    messagingSenderId: '208744369789',
    projectId: 'game-watch-3bd32',
    storageBucket: 'game-watch-3bd32.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuPCW6JNlgJbvPRGGuHV9ZrzNW9hhxAts',
    appId: '1:208744369789:ios:2d2d65e896917ef9612b14',
    messagingSenderId: '208744369789',
    projectId: 'game-watch-3bd32',
    storageBucket: 'game-watch-3bd32.firebasestorage.app',
    iosBundleId: 'com.example.gameReleaseCalendar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuPCW6JNlgJbvPRGGuHV9ZrzNW9hhxAts',
    appId: '1:208744369789:ios:2d2d65e896917ef9612b14',
    messagingSenderId: '208744369789',
    projectId: 'game-watch-3bd32',
    storageBucket: 'game-watch-3bd32.firebasestorage.app',
    iosBundleId: 'com.example.gameReleaseCalendar',
  );
}
