import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyRollCallApp());
}

class MyRollCallApp extends StatelessWidget {
  const MyRollCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyRollCall',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B4332), // Verde institucional
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const LoginPage(),
    );
  }
}