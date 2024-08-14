import 'package:automated_food_ordering_system/src/constants/image_strings.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/profile/email.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/profile/password.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/profile/phone_number.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/profile/username.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/profile/widgets/user_information_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserModel user = snapshot.data as UserModel;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(image: AssetImage(profileLogo))),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.orange,
                              ),
                              child: const Icon(
                                  LineAwesomeIcons.alternate_pencil,
                                  size: 20.0,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          UserInformationTile(
                            user: user,
                            title: 'Name:',
                            subtitle: user.fullName,
                            onPressed: () {
                              Get.to(() => const Username());
                            },
                          ),
                          const SizedBox(height: 10),
                          UserInformationTile(
                            user: user,
                            title: 'E-mail:',
                            subtitle: user.email,
                            onPressed: () {
                              Get.to(() => Email());
                            },
                          ),
                          const SizedBox(height: 10),
                          UserInformationTile(
                            user: user,
                            title: 'Phone Number:',
                            subtitle: user.phoneNo,
                            onPressed: () {
                              Get.to(() => const PhoneNumber());
                            },
                          ),
                          const SizedBox(height: 10),
                          UserInformationTile(
                            user: user,
                            title: 'Password:',
                            subtitle: '********',
                            onPressed: () {
                              Get.to(() => Password());
                            },
                          ),
                        ],
                      ),
                    ],
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
