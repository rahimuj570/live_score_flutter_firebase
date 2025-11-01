import 'package:flutter/material.dart';
import 'package:live_score_app2/signup_screen.dart';

class LiveScoreApp extends StatefulWidget {
  const LiveScoreApp({super.key});

  @override
  State<LiveScoreApp> createState() => _LiveScoreAppState();
}

class _LiveScoreAppState extends State<LiveScoreApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SignupScreen());
  }
}
