import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app2/home_screen.dart';
import 'package:live_score_app2/login_screen.dart';

class LiveScoreApp extends StatefulWidget {
  const LiveScoreApp({super.key});

  @override
  State<LiveScoreApp> createState() => _LiveScoreAppState();
}

class _LiveScoreAppState extends State<LiveScoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
