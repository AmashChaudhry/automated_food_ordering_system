import 'package:automated_food_ordering_system/src/constants/image_strings.dart';
import 'package:automated_food_ordering_system/src/constants/text_strings.dart';
import 'package:automated_food_ordering_system/src/constants/sizes.dart';
import 'package:automated_food_ordering_system/src/features/authentication/screens/login/login_screen.dart';
import 'package:automated_food_ordering_system/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage(welcomeImage), height: height * 0.4),
              const Column(
                children: [
                  Text(welcomeTitle,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(height: 10.0),
                  Text(
                    welcomeSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: const Text('LOGIN'),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const SignupScreen());
                      },
                      child: const Text('SIGNUP'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
