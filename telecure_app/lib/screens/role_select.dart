import 'package:flutter/material.dart';
import 'patient_resgistatrion.dart'; // Add this import at the top


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _selectedRole;

  final List<Map<String, dynamic>> _roles = [
    {
      "label": "Register as Patient",
      "value": "patient",
      "icon": Icons.person_outline,
    },
    {
      "label": "Register as Doctor",
      "value": "doctor",
      "icon": Icons.medical_services_outlined,
    },
    {
      "label": "Register as Pharmacy",
      "value": "pharmacy",
      "icon": Icons.local_pharmacy_outlined,
    },
    {
      "label": "Register as Hospital",
      "value": "hospital",
      "icon": Icons.local_hospital_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Primary accent used throughout; change as desired
    const Color primaryColor = Color(0xFF0081A7);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button + title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                          color: Color(0xFF1F324A),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Register to Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F324A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Registration options
                  for (final role in _roles) ...[
                    _RoleOptionTile(
                      label: role["label"] as String,
                      icon: role["icon"] as IconData,
                      selected: _selectedRole == role["value"],
                      onTap: () {
                        setState(() {
                          _selectedRole = role["value"] as String;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 20),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedRole == null
                          ? null
                          : () {
                              if (_selectedRole == "patient") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegistrationScreen()),
                                );
                              }
                              // You can add more conditions for other roles here
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedRole == null
                            ? const Color(0xFFDEE6EF)
                            : primaryColor,
                        foregroundColor: _selectedRole == null
                            ? const Color(0xFF94A3B8)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOptionTile extends StatelessWidget {
  const _RoleOptionTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0081A7);
    const borderColor = Color(0xFFE0E6EB);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? primaryColor : borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: selected
                  ? primaryColor.withOpacity(0.15)
                  : const Color(0xFFEAF6FF),
              child: Icon(
                icon,
                size: 20,
                color: selected ? primaryColor : const Color(0xFF84A3C5),
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
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: selected ? primaryColor : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
