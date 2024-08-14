import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ManageUserScreen extends StatelessWidget {
  ManageUserScreen({super.key});

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('Users');

  Future<void> deleteUserFromAuthentication(
      String email, String password) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.delete();
      if (kDebugMode) {
        print("User deleted from Firebase Authentication successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting user from Firebase Authentication: $e");
      }
    }
  }

  void deleteUserAndAccount(
      String userId, String email, String password) async {
    try {
      // First, delete the user from Firebase Authentication
      await deleteUserFromAuthentication(email, password);

      // Next, delete the user document from Firestore
      await _users.doc(userId).delete();

      if (kDebugMode) {
        print("User and account deleted successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting user and account: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Manage Users'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: _users.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (c, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Column(
                    children: [
                      Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            iconColor: Colors.orange,
                            leading: const Icon(LineAwesomeIcons.user_1),
                            title: Text(documentSnapshot['Full Name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(documentSnapshot['Phone']),
                                Text(documentSnapshot['Email']),
                                Text(documentSnapshot['Password']),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteUserAndAccount(
                                  documentSnapshot.id,
                                  documentSnapshot['Email'],
                                  documentSnapshot['Password'],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              );
            } else if (streamSnapshot.hasError) {
              return Center(child: Text(streamSnapshot.error.toString()));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}
