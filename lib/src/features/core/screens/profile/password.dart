import 'package:automated_food_ordering_system/src/constants/sizes.dart';
import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Password extends StatelessWidget {
  Password({Key? key}) : super(key: key);

  Future<void> updateRecord(String documentId, String password) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .update({
        'Password': password,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document: $e');
      }
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> changePassword(
      String email, String currentPassword, String newPassword) async {
    final cred =
        EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newPassword);
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
              final currentPassword = TextEditingController();
              final newPassword = TextEditingController();
              final confirmPassword = TextEditingController();

              return Scaffold(
                backgroundColor: const Color(0xFFF5F5F7),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(LineAwesomeIcons.angle_left)),
                  title: const Text('Password'),
                  centerTitle: true,
                ),
                body: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(defaultSize),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: currentPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Current Password',
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
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              errorStyle: const TextStyle(color: Colors.red),
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
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: newPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'New Password',
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
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              errorStyle: const TextStyle(color: Colors.red),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter new password';
                              } else if (value.length < 8) {
                                return 'Password length should not less than 8';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirmPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
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
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              errorStyle: const TextStyle(color: Colors.red),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter confirm password';
                              } else if (value.length < 8) {
                                return 'Password length should not less than 8';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (currentPassword.text == user.password &&
                                      newPassword.text ==
                                          confirmPassword.text) {
                                    await updateRecord(
                                      id.text,
                                      newPassword.text.trim(),
                                    );
                                    String email = user.email;
                                    await changePassword(email,
                                        currentPassword.text, newPassword.text);
                                    Get.back();
                                  } else if (newPassword.text !=
                                      confirmPassword.text) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        titlePadding:
                                            const EdgeInsets.only(top: 20),
                                        contentPadding: const EdgeInsets.only(
                                            top: 10, right: 10, left: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        title: const Icon(Icons.error_outline,
                                            color: Colors.red, size: 70),
                                        content: const Text(
                                          "Confirm Password didn't match to new password.",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("OK"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        titlePadding:
                                            const EdgeInsets.only(top: 20),
                                        contentPadding:
                                            const EdgeInsets.only(top: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        title: const Icon(Icons.error_outline,
                                            color: Colors.red, size: 70),
                                        content: const Text(
                                          "Current password is incorrect.",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("OK"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Update Password',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
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
