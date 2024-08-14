import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Username extends StatelessWidget {
  const Username({Key? key}) : super(key: key);

  Future<void> updateRecord(String documentId, String name) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .update({
        'Full Name': name,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document: $e');
      }
    }
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
              final fullName = TextEditingController(text: user.fullName);

              return Scaffold(
                backgroundColor: const Color(0xFFF5F5F7),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(LineAwesomeIcons.angle_left)),
                  title: const Text('Name',),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await updateRecord(
                          id.text,
                          fullName.text.trim(),
                        );
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
                      controller: fullName,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent),
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
