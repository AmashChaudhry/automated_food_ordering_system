import 'package:automated_food_ordering_system/src/features/authentication/screens/signup/signup_footer_widget.dart';
import 'package:automated_food_ordering_system/src/features/authentication/screens/signup/signup_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:automated_food_ordering_system/src/common_widgets/form/form_header_widget.dart';
import 'package:automated_food_ordering_system/src/constants/image_strings.dart';
import 'package:automated_food_ordering_system/src/constants/text_strings.dart';
import '../../../../constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormHeaderWidget(image: welcomeImage, title: signupTitle, subtitle: signupSubtitle),
              const SignupFormWidget(),
              const SignupFooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}