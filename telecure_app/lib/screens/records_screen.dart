import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

// ===== Models & helpers =====

enum RecordType { all, prescription, lab, visit, immunization, vitals }

class RecordItem {
  final String title; // e.g. "Prescription - Fever"
  final String facilityOrDoctor; // e.g. "Dr. Sharma" or "City Hospital"
  final DateTime date;
  final RecordType type;
  final String tag; // "PDF" | "Image" | "Note" | "Card"
  final bool pendingSync; // red dot

  const RecordItem({
    required this.title,
    required this.facilityOrDoctor,
    required this.date,
    required this.type,
    required this.tag,
    this.pendingSync = false,
  });
}

const _monthNames = <String>[
  'January','February','March','April','May','June',
  'July','August','September','October','November','December'
];

String formatDayShortMonthYear(DateTime d) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  final dd = d.day.toString().padLeft(2, '0');
  return '$dd ${months[d.month - 1]} ${d.year}';
}

String monthYearTitle(DateTime d) => '${_monthNames[d.month - 1]} ${d.year}';

IconData typeIcon(RecordType t) {
  switch (t) {
    case RecordType.prescription:
      return Icons.medication_outlined;
    case RecordType.lab:
      return Icons.biotech_outlined;
    case RecordType.visit:
      return Icons.event_note_outlined;
    case RecordType.immunization:
      return Icons.vaccines_outlined;
    case RecordType.vitals:
      return Icons.favorite_border;
    case RecordType.all:
      return Icons.folder_open;
  }
}

Color typeTint(BuildContext context, RecordType t) {
  final c = Theme.of(context).colorScheme;
  switch (t) {
    case RecordType.prescription:
      return Colors.indigo.shade100;
    case RecordType.lab:
      return Colors.red.shade100;
    case RecordType.visit:
      return Colors.green.shade100;
    case RecordType.immunization:
      return Colors.purple.shade100;
    case RecordType.vitals:
      return Colors.pink.shade100;
    case RecordType.all:
      return c.surfaceVariant;
  }
}

Color typeIconColor(BuildContext context, RecordType t) {
  switch (t) {
    case RecordType.prescription:
      return Colors.indigo;
    case RecordType.lab:
      return Colors.red;
    case RecordType.visit:
      return Colors.green;
    case RecordType.immunization:
      return Colors.purple;
    case RecordType.vitals:
      return Colors.pink;
    case RecordType.all:
      return Colors.grey;
  }
}

// ===== Screen =====

class _RecordsScreenState extends State<RecordsScreen> {
  final TextEditingController _search = TextEditingController();
  RecordType _filter = RecordType.all;
  bool _offline = true; // toggle to simulate offline banner
  String _language = 'EN'; // EN | हि | ਪੰ
  bool _cloudSynced = true; // cloud state icon

  late List<RecordItem> _all;

  @override
  void initState() {
    super.initState();
    _all = [
      // October 2024
      RecordItem(
        title: 'Prescription - Fever',
        facilityOrDoctor: 'Dr. Sharma',
        date: DateTime(2024, 10, 22),
        type: RecordType.prescription,
        tag: 'PDF',
      ),
      RecordItem(
        title: 'Lab Report - Blood Test',
        facilityOrDoctor: 'City Hospital',
        date: DateTime(2024, 10, 15),
        type: RecordType.lab,
        tag: 'Image',
        pendingSync: true, // red dot like in screenshot
      ),
      RecordItem(
        title: 'Visit Summary - Checkup',
        facilityOrDoctor: 'Dr. Singh',
        date: DateTime(2024, 10, 8),
        type: RecordType.visit,
        tag: '—',
      ),
      // September 2024
      RecordItem(
        title: 'Immunization - Flu Shot',
        facilityOrDoctor: 'Community Clinic',
        date: DateTime(2024, 9, 28),
        type: RecordType.immunization,
        tag: 'Note',
      ),
      RecordItem(
        title: 'Vitals - Blood Pressure',
        facilityOrDoctor: 'Dr. Verma',
        date: DateTime(2024, 9, 12),
        type: RecordType.vitals,
        tag: '—',
      ),
    ];
  }

  List<RecordItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _all.where((r) {
      final matchesType = _filter == RecordType.all || r.type == _filter;
      final matchesQuery = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.facilityOrDoctor.toLowerCase().contains(q) ||
          formatDayShortMonthYear(r.date).toLowerCase().contains(q);
      return matchesType && matchesQuery;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Map<String, List<RecordItem>> groupByMonth(List<RecordItem> items) {
    final map = <String, List<RecordItem>>{};
    for (final r in items) {
      final key = monthYearTitle(r.date);
      map.putIfAbsent(key, () => []).add(r);
    }
    // Keep groups in date-desc order
    final ordered = Map<String, List<RecordItem>>.fromEntries(
      (map.entries.toList()
        ..sort((a, b) {
          // parse month+year back to date to sort
          final ai = _monthNames.indexOf(a.key.split(' ')[0]) + 1;
          final ay = int.parse(a.key.split(' ')[1]);
          final bi = _monthNames.indexOf(b.key.split(' ')[0]) + 1;
          final by = int.parse(b.key.split(' ')[1]);
          return DateTime(by, bi).compareTo(DateTime(ay, ai));
        }))
          .reversed,
    );
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final grouped = groupByMonth(_filtered);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: const Text(
          'My Records',
          style: TextStyle(fontWeight: FontWeight.w800,
                          color: Colors.black),
        ),
        actions: [
          IconButton(
            tooltip: _cloudSynced ? 'Synced' : 'Not synced',
            onPressed: () => setState(() => _cloudSynced = !_cloudSynced),
            icon: Icon(
              _cloudSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            ),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                // simple cycle EN -> हि -> ਪੰ
                setState(() {
                  _language = _language == 'EN' ? 'हि' : _language == 'हि' ? 'ਪੰ' : 'EN';
                });
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _language == 'EN' ? 'EN | हि | ਪੰ' : _language,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearch(context)),
          SliverToBoxAdapter(child: _buildEmergencyCard(context)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _ChipHeaderDelegate(
              minExtent: 64,
              maxExtent: 64,
              child: Material(
                color: cs.surface,
                child: _buildChipsRow(context),
              ),
            ),
          ),
          ...grouped.entries.map((e) => _MonthSection(title: e.key, items: e.value)),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
      floatingActionButton: _buildFAB(context),
      // bottomNavigationBar: _offline
      //     ? Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //         decoration: BoxDecoration(
      //           color: const Color(0xFFFFF3CD),
      //           border: Border(top: BorderSide(color: Colors.amber.shade300)),
      //         ),
      //         child: Row(
      //           children: const [
      //             Icon(Icons.wifi_off, size: 18),
      //             SizedBox(width: 8),
      //             Expanded(
      //               child: Text(
      //                 'Available offline. Some features may be limited.',
      //                 style: TextStyle(fontWeight: FontWeight.w600),
      //               ),
      //             ),
      //           ],
      //         ),
      //       )
          bottomNavigationBar: const SharedBottomNav(currentIndex: 2)
    );
  }

  Widget _buildSearch(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        controller: _search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by doctor, date, or type',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: cs.surfaceVariant.withOpacity(0.5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: cs.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Emergency Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Show full info',
                    style: TextStyle(
                      color: Colors.indigo.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _emCol('Blood Group', 'O+'),
                _emCol('Allergies', 'None'),
                _emCol('Chronic Meds', 'None'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsRow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget chip(RecordType t, String label) {
      final selected = _filter == t;
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          selected: selected,
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          onSelected: (_) => setState(() => _filter = t),
          selectedColor: Colors.tealAccent.shade100,
          backgroundColor: cs.surfaceVariant.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          labelPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          chip(RecordType.all, 'All'),
          chip(RecordType.prescription, 'Prescriptions'),
          chip(RecordType.lab, 'Lab'),
          chip(RecordType.visit, 'Visits'),
          chip(RecordType.immunization, 'Immunizations'),
          chip(RecordType.vitals, 'Vitals'),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetTile(
                    icon: Icons.photo_camera_outlined,
                    text: 'Scan with camera',
                    onTap: () => Navigator.pop(ctx),
                  ),
                  _sheetTile(
                    icon: Icons.upload_file_outlined,
                    text: 'Upload file',
                    onTap: () => Navigator.pop(ctx),
                  ),
                  _sheetTile(
                    icon: Icons.note_add_outlined,
                    text: 'Add note',
                    onTap: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  // helpers
  static Widget _sheetTile({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      onTap: onTap,
    );
  }

  static Widget _emCol(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

// ===== Sticky header delegate for chips row =====
class _ChipHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _ChipHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _ChipHeaderDelegate oldDelegate) {
    return oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent ||
        oldDelegate.child != child;
  }
}

// ===== Month section (title + cards) =====

class _MonthSection extends StatelessWidget {
  final String title;
  final List<RecordItem> items;

  const _MonthSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  TextStyle(color: cs.onSurface.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            ...items.map((r) => _RecordCard(item: r)),
          ],
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final RecordItem item;
  const _RecordCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final tag = item.tag == '—'
        ? null
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(item.tag, style: const TextStyle(fontWeight: FontWeight.w700)),
          );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: typeTint(context, item.type),
              child: Icon(typeIcon(item.type), color: typeIconColor(context, item.type)),
            ),
            if (item.pendingSync)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${item.facilityOrDoctor} · ${formatDayShortMonthYear(item.date)}',
            style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tag != null) tag,
            const SizedBox(width: 6),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (v) {},
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'open', child: Text('Open')),
                PopupMenuItem(value: 'share', child: Text('Share')),
                PopupMenuItem(value: 'download', child: Text('Download')),
                PopupMenuItem(value: 'rename', child: Text('Rename')),
                PopupMenuItem(value: 'move', child: Text('Move to Folder')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
