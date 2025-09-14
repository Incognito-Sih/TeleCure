import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';

class ComingSoonScreen extends StatelessWidget {
  final int currentIndex;
  final String feature;

  const ComingSoonScreen({
    super.key,
    required this.currentIndex,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          feature,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.upcoming_outlined,
              size: 64,
              color: Color(0xFF0081A7),
            ),
            const SizedBox(height: 16),
            Text(
              '$feature Coming Soon!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('We\'re working hard to bring you this feature.'),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNav(currentIndex: currentIndex),
    );
  }
}