import 'package:flutter/material.dart';
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
      // Preferred: asset flag; fallback: badge text
      "asset": "assets/flags/en.png"
    },
    {
      "name": "हिंदी", // Hindi label in Hindi
      "code": "hi",
      "asset": "assets/flags/hi.png"
    },
    {
      "name": "ਪੰਜਾਬੀ", // Punjabi label in Punjabi (Gurmukhi)
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
        // If the asset is missing, show a clean text badge fallback
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Builder(
          builder: (context) {
            final double statusBar = MediaQuery.of(context).padding.top;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blue header covering the status bar area
                Container(
                  width: double.infinity,
                  color: Colors.teal,
                  padding: EdgeInsets.fromLTRB(
                    20,
                    statusBar + 20,
                    20,
                    20,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Your Language",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Select your preferred language to continue.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Language options
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
                                        fontWeight: FontWeight.w500),
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

                // Continue button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
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
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
