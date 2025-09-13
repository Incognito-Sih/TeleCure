import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    // TODO: Navigate to other pages based on index if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: const Color(0xFF0081A7),
        unselectedItemColor: const Color(0xFF94A3B8),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call_outlined),
            label: 'Consult',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_outlined),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header with app name and notification icon
              Row(
                children: [
                  SizedBox(width: 18),
                  Image.asset(
                    'assets/app_logo.png',
                    width: 30,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'TeleCure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F324A),
                        ),
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF4F5D72),
                          ),
                          onPressed: () {
                            // TODO: Notification action
                          },
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE11D48),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                // Welcome card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Welcome, User!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F324A),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Your health is our priority.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4F5D72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0081A7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Quick Access header
                const Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F324A),
                  ),
                ),
                const SizedBox(height: 12),
                // Quick Access grid
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _QuickAccessItem(
                      icon: Icons.video_call_outlined,
                      label: 'Video Consultation',
                      onTap: () {
                        // TODO: Navigate to Video Consultation
                      },
                    ),
                    _QuickAccessItem(
                      icon: Icons.location_on_outlined,
                      label: 'Nearby Clinics',
                      onTap: () {
                        // TODO: Navigate to Nearby Clinics
                      },
                    ),
                    _QuickAccessItem(
                      icon: Icons.local_pharmacy_outlined,
                      label: 'Medicine',
                      onTap: () {
                        // TODO: Navigate to Medicine
                      },
                    ),
                    _QuickAccessItem(
                      icon: Icons.folder_open_outlined,
                      label: 'Health Records',
                      onTap: () {
                        // TODO: Navigate to Health Records
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Profile & Settings header
                const Text(
                  'Profile & Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F324A),
                  ),
                ),
                const SizedBox(height: 12),
                _SettingsItem(
                  icon: Icons.language_outlined,
                  label: 'Change Language',
                  onTap: () {
                    // TODO: Navigate to Change Language
                  },
                ),
                const SizedBox(height: 12),
                _SettingsItem(
                  icon: Icons.psychology_outlined,
                  label: 'AI Symptom Checker',
                  onTap: () {
                    // TODO: Navigate to AI Symptom Checker
                  },
                ),
                const SizedBox(height: 12),
                _SettingsItem(
                  icon: Icons.local_hospital_outlined,
                  label: 'Emergency Help',
                  onTap: () {
                    // TODO: Navigate to Emergency Help
                  },
                ),
                const SizedBox(height: 12),
                _SettingsItem(
                  icon: Icons.health_and_safety_outlined,
                  label: 'Health Tips & Awareness',
                  onTap: () {
                    // TODO: Navigate to Health Tips & Awareness
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }
  }

  // Widget for quick access items
  class _QuickAccessItem extends StatelessWidget {
    const _QuickAccessItem({
      required this.icon,
      required this.label,
      required this.onTap,  
      Key? key,
    }) : super(key: key);

    final IconData icon;
    final String label;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E6EB)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF0081A7).withOpacity(0.15),
                child: Icon(
                  icon,
                  color: const Color(0xFF0081A7),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F324A),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Widget for list items in Profile & Settings
  class _SettingsItem extends StatelessWidget {
    const _SettingsItem({
      required this.icon,
      required this.label,
      required this.onTap,
      Key? key,
    }) : super(key: key);

    final IconData icon;
    final String label;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE0E6EB)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF0081A7).withOpacity(0.15),
                child: Icon(
                  icon,
                  color: const Color(0xFF0081A7),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F324A),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      );
    }
  }
