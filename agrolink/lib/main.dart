import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AgroLinkApp());
}

class AgroLinkApp extends StatelessWidget {
  const AgroLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}