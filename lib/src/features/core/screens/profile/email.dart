import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Email extends StatelessWidget {
  Email({Key? key}) : super(key: key);

  Future<void> updateRecord(String documentId, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .update({
        'Email': email,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document: $e');
      }
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> changeEmail(
      String email, String currentPassword, String newEmail) async {
    final cred =
        EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updateEmail(newEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserModel user = snapshot.data as UserModel;

              final id = TextEditingController(text: user.id);
              final email = TextEditingController(text: user.email);
              final password = TextEditingController(text: user.password);

              return Scaffold(
                backgroundColor: const Color(0xFFF5F5F7),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(LineAwesomeIcons.angle_left)),
                  title: const Text('E-mail'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await updateRecord(
                          id.text,
                          email.text.trim(),
                        );
                        String cEmail = user.email;
                        await changeEmail(cEmail, password.text, email.text);
                        Get.back();
                      },
                      icon: const Icon(
                        LineAwesomeIcons.check,
                      ),
                    ),
                  ],
                ),
                body: Container(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
