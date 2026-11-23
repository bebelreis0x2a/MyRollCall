import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o SQLite para Windows/Linux Desktop (no Android já funciona direto)
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDkx_2e4A6Mx73CuOBw4atKKMT5GdTid0w',
      appId: '1:941428615320:web:9850cfe447a45f33bc48ed',
      messagingSenderId: '941428615320',
      projectId: 'myrollcall-ab880',
    ),
  );

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
          seedColor: const Color(0xFF1B4332),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const LoginPage(),
    );
  }
}
