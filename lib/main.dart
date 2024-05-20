import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix_1/screens/homescreen.dart';
import 'package:netflix_1/screens/splash_screen.dart';

import 'package:netflix_1/signup_in/signin.dart';

void main() async {
  /**
   * const firebaseConfig = {
  apiKey: "AIzaSyCmXj47qZ8SFkixETnBed2L10ks1oNfwak",
  authDomain: "netflixproject-f8a88.firebaseapp.com",
  projectId: "netflixproject-f8a88",
  storageBucket: "netflixproject-f8a88.appspot.com",
  messagingSenderId: "1080722281246",
  appId: "1:1080722281246:web:77b100a0d7a6df0b77af0f"
  };
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCmXj47qZ8SFkixETnBed2L10ks1oNfwak",
      authDomain: "netflixproject-f8a88.firebaseapp.com",
      projectId: "netflixproject-f8a88",
      storageBucket: "netflixproject-f8a88.appspot.com",
      messagingSenderId: "1080722281246",
      appId: "1:1080722281246:web:77b100a0d7a6df0b77af0f",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            //fontSize: 24,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            //fontSize: 20,
          ),
        ),
        fontFamily: GoogleFonts.ptSans().fontFamily,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
            .copyWith(background: Colors.black),
      ),
      home: const SplashScreen(),
    );
  }
}
