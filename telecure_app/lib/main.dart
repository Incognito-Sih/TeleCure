import 'package:flutter/material.dart';
import 'screens/language_select_screen.dart';


void main() {
  runApp(const TeleCureApp());
}

class TeleCureApp extends StatelessWidget {
  const TeleCureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleCure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const LanguageSelectScreen(),
    );
  }
}
