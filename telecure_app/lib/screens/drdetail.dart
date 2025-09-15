import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language_controller.dart';
import '../localization_strings.dart';

class DrDetailsSheet extends StatelessWidget {
  const DrDetailsSheet({
    super.key,
    required this.doctor,
    required this.onStartVideo,
    required this.onStartAudio,
    this.onSendMessage,
  });

  final Doctor doctor;
  final VoidCallback onStartVideo;
  final VoidCallback onStartAudio;
  final VoidCallback? onSendMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langCode = Provider.of<LanguageController>(context).locale.languageCode;
    final strings = localizedStrings1[langCode]!;

    const brandTeal = Color(0xFF00D0C6);
    const tipBg = Color(0xFFEAFBF7);
    const tipIcon = Color(0xFF18A999);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(online: doctor.isOnline, name: doctor.name),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${doctor.experienceYrs}+ ${strings['yearsExperience']}',
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (doctor.bio.isNotEmpty)
              Text(
                doctor.bio,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),

            const SizedBox(height: 18),
            Text(strings['qualifications']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              _qualificationFallback(doctor),
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),

            const SizedBox(height: 18),
            Text(strings['languages']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctor.languages.map((l) => _LangChip(l)).toList(),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: tipBg, borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.podcasts_rounded, color: tipIcon),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings['connectionTipTitle']!,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: tipIcon),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings['connectionTipBody']!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: doctor.supportsVideo ? onStartVideo : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
                child: Text(strings['startVideo']!),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: doctor.supportsAudio ? onStartAudio : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECEDEF),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
                child: Text(strings['startAudio']!),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: TextButton(
                onPressed: doctor.supportsChat ? (onSendMessage ?? () {}) : null,
                child: Text(
                  strings['sendMessage']!,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                strings['consentNotice']!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _qualificationFallback(Doctor d) {
    return 'MD, ${d.specialty}';
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({super.key, required this.online, required this.name});
  final bool online;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFE8F7FA),
          child: Text(
            _initials(name),
            style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF10C3E6)),
          ),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: online ? const Color(0xFF21C45A) : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  String _initials(String fullName) {
    final parts = fullName.split(' ').where((e) => e.trim().isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class Doctor {
  final String name;
  final String specialty;
  final int experienceYrs;
  final List<String> languages;
  final bool isOnline;
  final bool supportsVideo;
  final bool supportsAudio;
  final bool supportsChat;
  final String bio;
  const Doctor({
    required this.name,
    required this.specialty,
    required this.experienceYrs,
    required this.languages,
    this.isOnline = true,
    this.supportsVideo = true,
    this.supportsAudio = true,
    this.supportsChat = true,
    this.bio = '',
  });
}
