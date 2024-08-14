import 'package:automated_food_ordering_system/src/features/authentication/controllers/signup_controller.dart';
import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/sizes.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullName,
              decoration: const InputDecoration(
                label: Text('Full Name'),
                prefixIcon: Icon(Icons.person_outline_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: formHeight - 20.0),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                label: Text('E-mail'),
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email address';
                } else if (!value.contains('@')) {
                  return 'Please enter valid email address';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: formHeight - 20.0),
            TextFormField(
              controller: controller.phoneNo,
              decoration: const InputDecoration(
                label: Text('Phone No.'),
                prefixIcon: Icon(LineAwesomeIcons.phone),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter phone number';
                } else if (!value.contains('+')) {
                  return 'Enter complete phone no. e.g.(+92)';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: formHeight - 20.0),
            TextFormField(
              controller: controller.password,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Password'),
                prefixIcon: Icon(Icons.fingerprint),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                } else if (value.length < 8) {
                  return 'Password length should not less than 8';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: formHeight - 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    SignupController.instance.registerUser(
                        controller.email.text.trim(),
                        controller.password.text.trim());
                    final user = UserModel(
                      fullName: controller.fullName.text.trim(),
                      email: controller.email.text.trim(),
                      phoneNo: controller.phoneNo.text.trim(),
                      password: controller.password.text.trim(),
                      address: '',
                      location: const GeoPoint(0.0, 0.0),
                    );
                    SignupController.instance.createUser(user);
                    // SignupController.instance.phoneAuthentication(controller.phoneNo.text.trim());
                  }
                },
                child: const Text('SIGNUP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
