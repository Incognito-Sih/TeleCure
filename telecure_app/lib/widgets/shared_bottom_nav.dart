import 'package:flutter/material.dart';
import 'package:telecure_app/screens/records_screen.dart';
import '../screens/home_screen.dart';
import '../screens/video_consultation_screen.dart';
import '../screens/coming_soon_screen.dart';
import '../utils/route_transitions.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex;
  
  const SharedBottomNav({
    super.key, 
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              FadePageRoute(page: const HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              FadePageRoute(page: const VideoConsultationScreen()),
            );
            break;
          case 2:
          Navigator.pushReplacement(
              context,
              FadePageRoute(page: const RecordsScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              FadePageRoute(page: const ComingSoonScreen(
                currentIndex: 3,
                feature: 'Profile',
              )),
            );
            break;
        }
      },
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
    );
  }
}