import 'package:automated_food_ordering_system/src/constants/sizes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Automated Food Ordering System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
