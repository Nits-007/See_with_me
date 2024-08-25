import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:see_with_me/frontend/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAk4CsXjYajS2ke3HkUW3oM7Oc1uZwMjxs",
      authDomain: "seewithme-efea4.firebaseapp.com",
      projectId: "seewithme-efea4",
      storageBucket: "seewithme-efea4.appspot.com",
      messagingSenderId: "503667879329",
      appId: "1:503667879329:android:6d656cefe352d79c876fe0",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
