import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_controller.dart';
import 'screens/language_select_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageController(),
      child: const TeleCureApp(),
    ),
  );
}

class TeleCureApp extends StatelessWidget {
  const TeleCureApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Provider.of<LanguageController>(context);

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
