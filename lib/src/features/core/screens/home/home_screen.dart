import 'package:automated_food_ordering_system/src/constants/image_strings.dart';
import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/menu/menu_screen.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/home/widgets/drawer_tile_widget.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/manage_users/manage_users.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/profile/profile_screen.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/table_reservation/table_reservation.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/user_location/user_location.dart';
import 'package:automated_food_ordering_system/src/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: Drawer(
          backgroundColor: const Color(0xFFF5F5F7),
          child: ListView(
            children: [
              Container(
                height: 160,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(image: AssetImage(profileLogo))),
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: controller.getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            UserModel userData = snapshot.data as UserModel;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      userData.fullName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      userData.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const UpdateProfileScreen());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 10),
                                      child: Center(
                                        child: Text(
                                          'Profile',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return const Center(
                                child: Text('Something went wrong'));
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Divider(color: Colors.orange.withOpacity(0.4)),
                    const SizedBox(height: 10),
                    ProfileTileWidget(
                      title: 'Billing Details',
                      icon: LineAwesomeIcons.wallet,
                      onPress: () {},
                    ),
                    ProfileTileWidget(
                      title: 'User Management',
                      icon: LineAwesomeIcons.user_check,
                      onPress: () {
                        Get.to(() => ManageUserScreen());
                      },
                    ),
                    ProfileTileWidget(
                      title: 'Address',
                      icon: LineAwesomeIcons.map,
                      onPress: () {
                        Get.to(() => const UserLocation());
                      },
                    ),
                    ProfileTileWidget(
                      title: 'Settings',
                      icon: LineAwesomeIcons.cog,
                      onPress: () {},
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.orange.withOpacity(0.4)),
                    const SizedBox(height: 10),
                    ProfileTileWidget(
                      title: 'Information',
                      icon: LineAwesomeIcons.info,
                      onPress: () {},
                    ),
                    ProfileTileWidget(
                      title: 'Logout',
                      icon: LineAwesomeIcons.alternate_sign_out,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        AuthenticationRepository.instance.logout();
                        Get.offAll(() => const WelcomeScreen());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const MenuScreen(
                              orderType: 'Delivery',
                            ));
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Ink(
                        height: 220,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage(deliveryImage),
                                  height: 100),
                              const SizedBox(height: 15),
                              const Text(
                                'Food delivery',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Satisfy Cravings, Anywhere, Anytime!',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const MenuScreen(
                              orderType: 'DineIn',
                            ));
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Ink(
                        height: 220,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage(dineInImage), height: 100),
                              const SizedBox(height: 15),
                              const Text(
                                'Dine-in',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Order your favourite food and enjoy',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Get.to(() => const TableReservation());
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Ink(
                  height: 180,
                  width: double.infinity,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Reserve Table',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Guarantee Your Spot: Table Reservation Available!',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image(
                            image: AssetImage(reserveTableImage), height: 100),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
