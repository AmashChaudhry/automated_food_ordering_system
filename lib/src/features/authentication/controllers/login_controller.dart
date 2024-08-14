import 'package:automated_food_ordering_system/src/features/authentication/screens/verify_email/verify_email.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/home/home_screen.dart';
import 'package:automated_food_ordering_system/src/repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    String? error = await AuthenticationRepository.instance
        .loginWithEmailAndPassword(email, password);
    if (FirebaseAuth.instance.currentUser == null) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
    } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      Get.offAll(() => const VerifyEmail());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }
}
