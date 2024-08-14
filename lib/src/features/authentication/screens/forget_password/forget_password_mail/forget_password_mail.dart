import 'package:automated_food_ordering_system/src/common_widgets/form/form_header_widget.dart';
import 'package:automated_food_ordering_system/src/constants/image_strings.dart';
import 'package:automated_food_ordering_system/src/constants/text_strings.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/sizes.dart';
import '../forget_password_otp/forget_password_otp.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              const SizedBox(height: defaultSize * 4),
              FormHeaderWidget(
                image: recoverPasswordImage,
                title: forgetMailTitle,
                subtitle: forgetMailSubtitle,
                crossAxisAlignment: CrossAxisAlignment.center,
                heightBetween: 30.0,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: formHeight),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                        labelText: 'Email',
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OTPScreen()),
                            );
                          },
                          child: const Text('NEXT'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
