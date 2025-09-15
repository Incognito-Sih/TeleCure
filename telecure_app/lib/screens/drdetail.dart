import 'package:flutter/material.dart';

/// Drop-in replacement for DrDetailsSheet matching the mockup.
/// Paste this into your project and replace the existing DrDetailsSheet
/// in video_consultation_screen.dart.
/// It reuses your existing `Doctor` model and callbacks.

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
    const brandTeal = Color(0xFF00D0C6); // bright teal button from mock
    const tipBg = Color(0xFFEAFBF7); // light aqua background
    const tipIcon = Color(0xFF18A999);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
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

            // Header
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
                        '${doctor.experienceYrs}+ years experience',
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
            Text('Qualifications', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              _qualificationFallback(doctor),
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),

            const SizedBox(height: 18),
            Text('Languages', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctor.languages.map((l) => _LangChip(l)).toList(),
            ),

            const SizedBox(height: 20),
            // Connection tip card
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
                          'Connection health tip',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: tipIcon),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'On slow networks, start with Audio; you can upgrade to Video.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Start Video
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
                child: const Text('Start Video'),
              ),
            ),

            const SizedBox(height: 12),

            // Start Audio (subtle gray)
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
                child: const Text('Start Audio'),
              ),
            ),

            const SizedBox(height: 16),

            // Send Message
            Center(
              child: TextButton(
                onPressed: doctor.supportsChat ? (onSendMessage ?? () {}) : null,
                child: const Text(
                  'Send Message',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Consent microcopy
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Your call is encrypted. By continuing you agree to TeleCure’s consent policy.',
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
    // If you later add a field like `d.qualifications`, show that instead.
    // For now, provide a sensible default based on specialty.
    return 'MD, ${d.specialty}';
  }
}

// Chips & Avatar reusing your styles
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

/// Dummy Doctor model to make this snippet self-contained during preview.
/// Delete this block if you already have `Doctor` in scope.
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
