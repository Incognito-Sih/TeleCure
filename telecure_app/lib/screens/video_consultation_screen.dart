import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';
import 'video_call_screen.dart';

/// Video Consultation (UI match for provided mockup)
/// - Place at: lib/screens/video_consultation_screen.dart
/// - No external packages. Pure Flutter widgets.
/// - Includes: rounded search, filter pills, low-data banner,
///   doctor cards (online/offline), and bottom nav.

class VideoConsultationScreen extends StatefulWidget {
  const VideoConsultationScreen({super.key});

  @override
  State<VideoConsultationScreen> createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  final TextEditingController _search = TextEditingController();
  String query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF10C3E6); // primary accent (Call now)
    const successBg = Color(0xFFE9FBF1);
    const success = Color(0xFF16A249);

    final filtered = _sampleDoctors.where((d) {
      if (query.isEmpty) return true;
      final q = query.toLowerCase();
      return d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q) ||
          d.goodFor.any((e) => e.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text(
          'Video Consultation',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => _showHelp(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _RoundedSearchField(
                controller: _search,
                hint: 'Search by name, specialty, symptom…',
                onChanged: (v) => setState(() => query = v),
              ),
            ),

            // Filter row (pills that open sheets — stubbed)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterPill(label: 'Specialty', onTap: () => _openStubSheet(context, 'Specialty')),
                  _FilterPill(label: 'Language', onTap: () => _openStubSheet(context, 'Language')),
                  _FilterPill(label: 'Availability', onTap: () => _openStubSheet(context, 'Availability')),
                ],
              ),
            ),

            // Low-data banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: successBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.signal_cellular_alt_rounded, color: success),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Works on low data. ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openLowDataTips(context),
                      child: const Text(
                        'Learn more',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemBuilder: (_, i) => _DoctorCard(doctor: filtered[i], brand: brand, onTap: () => _showDoctorDetails(context, filtered[i])),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemCount: filtered.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 1),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Need help?'),
        content: const Text(
          'Search a doctor by name, specialty, or symptom. Use the filter pills to narrow results. Tap a card to call or book.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _openLowDataTips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Low-data tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 8),
            Text('• Prefer Audio first, upgrade to Video later.'),
            Text('• Keep other apps closed to free bandwidth.'),
            Text('• Move closer to your Wi‑Fi router if possible.'),
          ],
        ),
      ),
    );
  }

  void _openStubSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Hook up real filters to your backend. This is a UI placeholder.'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
            )
          ],
        ),
      ),
    );
  }

  // First, add this method to show the bottom sheet
  void _showDoctorDetails(BuildContext context, _Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _AvatarWithStatus(name: doctor.name, online: doctor.online),
              title: Text(
                doctor.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              subtitle: Text(doctor.specialty),
            ),
            const Divider(),

            // Call Options
            ListTile(
              leading: const Icon(Icons.videocam_rounded, color: Color(0xFF10C3E6)),
              title: const Text('Start Video Call'),
              onTap: () {
              // capture a root navigator BEFORE popping the sheet
                    final nav = Navigator.of(context, rootNavigator: true);

                    Navigator.pop(context); // close the bottom sheet

  // push on next microtask using the captured navigator
                    Future.microtask(() {
                    nav.push(
                    MaterialPageRoute(
                    builder: (_) => VideoCallPlaceholder(
                    doctorName: doctor.name,
                    specialty: doctor.specialty,
                    mode: CallMode.video, // from your call file
                      ),
                    ),
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.call_rounded, color: Color(0xFF10C3E6)),
              title: const Text('Start Audio Call'),
              onTap: () {
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoCallPlaceholder(
                        doctorName: doctor.name,
                        specialty: doctor.specialty,
                        mode: CallMode.audio,
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ————————————————————————————————————————
// Widgets
// ————————————————————————————————————————

class _RoundedSearchField extends StatelessWidget {
  const _RoundedSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black.withOpacity(.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFF10C3E6), width: 1.4),
        ),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({super.key, required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withOpacity(.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({super.key, required this.doctor, required this.brand, required this.onTap});
  final _Doctor doctor;
  final Color brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AvatarWithStatus(name: doctor.name, online: doctor.online),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                doctor.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doctor.specialty,
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.black.withOpacity(.6)),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text('${doctor.yearsExp}+ yrs exp.', style: _dim()),
                            _dot(),
                            Text('${doctor.consults}+ consults', style: _dim()),
                            _dot(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                const SizedBox(width: 2),
                                Text(doctor.rating.toStringAsFixed(1), style: _dim()),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: -8,
                          children: doctor.languages.map((l) => _LangChip(l)).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              Row(
                children: [
                  _tinyIcon(Icons.videocam_rounded),
                  const SizedBox(width: 8),
                  _tinyIcon(Icons.call_rounded),
                  const SizedBox(width: 8),
                  _tinyIcon(Icons.chat_bubble_outline_rounded),
                  const Spacer(),
                  if (doctor.online)
                    _CallButton(
                      label: 'Call now',
                      brand: brand,
                      icon: Icons.call_rounded,
                      onPressed: onTap,
                    )
                  else
                    _OutlinedPillButton(
                      label: 'Book',
                      icon: Icons.calendar_month_rounded,
                      onPressed: () {},
                    ),
                ],
              ),

              const SizedBox(height: 12),
              Text(
                'Good for: ${doctor.goodFor.join(', ')}',
                style: TextStyle(color: Colors.black.withOpacity(.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _dim() => const TextStyle(color: Color(0xFF6B7280));

  Widget _dot() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(color: Color(0xFF9CA3AF), shape: BoxShape.circle),
      );

  Widget _tinyIcon(IconData icon) => Icon(icon, size: 20, color: Colors.black.withOpacity(.6));
}

class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({super.key, required this.name, required this.online});
  final String name;
  final bool online;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFE8F7FA),
          child: Text(
            _initials(name),
            style: const TextStyle(color: Color(0xFF10C3E6), fontWeight: FontWeight.w800),
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
        )
      ],
    );
  }

  String _initials(String v) {
    final parts = v.trim().split(RegExp('\\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({super.key, required this.label, required this.brand, required this.icon, required this.onPressed});
  final String label;
  final Color brand;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: brand,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  const _OutlinedPillButton({super.key, required this.label, required this.icon, required this.onPressed});
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: const StadiumBorder(),
      ),
    );
  }
}

// ————————————————————————————————————————
// Model + sample data
// ————————————————————————————————————————

class _Doctor {
  final String name;
  final String specialty;
  final int yearsExp; // rounded display
  final int consults; // rounded display e.g., 1k+
  final double rating;
  final List<String> languages;
  final bool online;
  final List<String> goodFor;
  const _Doctor({
    required this.name,
    required this.specialty,
    required this.yearsExp,
    required this.consults,
    required this.rating,
    required this.languages,
    required this.online,
    required this.goodFor,
  });
}

final _sampleDoctors = <_Doctor>[
  const _Doctor(
    name: 'Dr. Priya Sharma',
    specialty: 'General Physician',
    yearsExp: 10,
    consults: 1000,
    rating: 4.8,
    languages: ['EN', 'HI', 'PA'],
    online: true,
    goodFor: ['fever', 'cough', 'viral'],
  ),
  const _Doctor(
    name: 'Dr. Arjun Kapoor',
    specialty: 'Pediatrician',
    yearsExp: 8,
    consults: 800,
    rating: 4.9,
    languages: ['EN', 'HI'],
    online: false,
    goodFor: ['child fever', 'vaccination'],
  ),
  const _Doctor(
    name: 'Dr. Meera Patel',
    specialty: 'Dermatologist',
    yearsExp: 6,
    consults: 600,
    rating: 4.6,
    languages: ['EN'],
    online: true,
    goodFor: ['skin rash', 'acne', 'eczema'],
  ),
];
