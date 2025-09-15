import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: Provider.of<LanguageController>(context).locale,
      items: const [
        DropdownMenuItem(child: Text('English'), value: Locale('en')),
        DropdownMenuItem(child: Text('हिन्दी'), value: Locale('hi')),
        DropdownMenuItem(child: Text('ਪੰਜਾਬੀ'), value: Locale('pa')),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          Provider.of<LanguageController>(context, listen: false).setLocale(newLocale);
        }
      },
    );
  }
}
