import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language_controller.dart';
import '../localization_strings.dart';
import 'package:telecure_app/screens/login_screen.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  String? _selectedLanguage;

  final List<Map<String, String>> languages = [
    {
      "name": "English",
      "code": "en",
      "asset": "assets/flags/en.png"
    },
    {
      "name": "हिंदी",
      "code": "hi",
      "asset": "assets/flags/hi.png"
    },
    {
      "name": "ਪੰਜਾਬੀ",
      "code": "pa",
      "asset": "assets/flags/pa.png"
    },
  ];

  String _badgeText(String code) {
    switch (code) {
      case 'en':
        return 'A';
      case 'hi':
        return 'अ';
      case 'pa':
        return 'ਪ';
      default:
        return '🌐';
    }
  }

  Widget _languageBadge(Map<String, String> lang) {
    final assetPath = lang['asset'] ?? '';
    final text = _badgeText(lang['code'] ?? '');
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Image.asset(
        assetPath,
        width: 28,
        height: 28,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: 14,
          backgroundColor: Colors.teal.withOpacity(0.12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }

  void _applyLanguage(BuildContext context) {
    if (_selectedLanguage != null) {
      final locale = Locale(_selectedLanguage!);
      Provider.of<LanguageController>(context, listen: false).setLocale(locale);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;
    final langCode = Provider.of<LanguageController>(context).locale.languageCode;
    final strings = localizedStrings[langCode]!;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.teal,
              padding: EdgeInsets.fromLTRB(20, statusBar + 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings['chooseLanguage']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings['selectPrompt']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = lang["code"];
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedLanguage == lang["code"]
                                ? Colors.teal
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            _languageBadge(lang),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                lang["name"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Radio<String>(
                              value: lang["code"]!,
                              groupValue: _selectedLanguage,
                              activeColor: Colors.teal,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLanguage = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedLanguage == null
                      ? null
                      : () => _applyLanguage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedLanguage == null
                        ? Colors.grey.shade300
                        : Colors.teal,
                    foregroundColor: _selectedLanguage == null
                        ? Colors.grey
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    strings['continue']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
