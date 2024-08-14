import 'package:automated_food_ordering_system/src/constants/image_strings.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/cart/cart.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/menu/widgets/category_icon.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/item_details/item_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ignore: must_be_immutable
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.orderType});

  final String orderType;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<dynamic> result = [];
  List<String> items = [];
  List<Map<String, int>> quantity = [];
  List<Color> newColor = [Colors.white, Colors.white, Colors.white, Colors.white];
  List<bool> isButtonPressed = [false, false, false, false];

  final CollectionReference _foodItems =
      FirebaseFirestore.instance.collection('Food Items');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          title: const Text('Menu'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFFF5F5F7),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                onPressed: () {
                  Get.to(() => Cart(
                        itemId: items,
                        quantity: quantity,
                        orderType: widget.orderType,
                      ));
                },
                icon: const Icon(
                  LineAwesomeIcons.shopping_bag,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    isCollapsed: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    prefixIconConstraints: const BoxConstraints(minWidth: 45),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          CategoryIcon(
                            category: 'Burger',
                            logo: burgerLogo,
                            boxColor: newColor[0],
                            onTap: () {
                              setState(() {
                                isButtonPressed[0] = !isButtonPressed[0];
                                if (isButtonPressed[0] == true) {
                                  newColor[0] = Colors.orange.shade400;
                                  isButtonPressed[1] = false;
                                  isButtonPressed[2] = false;
                                  isButtonPressed[3] = false;
                                  newColor[1] = Colors.white;
                                  newColor[2] = Colors.white;
                                  newColor[3] = Colors.white;
                                } else {
                                  newColor[0] = Colors.white;
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          CategoryIcon(
                            category: 'Pizza',
                            logo: pizzaLogo,
                            boxColor: newColor[1],
                            onTap: () {
                              setState(() {
                                isButtonPressed[1] = !isButtonPressed[1];
                                if (isButtonPressed[1] == true) {
                                  newColor[1] = Colors.orange.shade400;
                                  isButtonPressed[0] = false;
                                  isButtonPressed[2] = false;
                                  isButtonPressed[3] = false;
                                  newColor[0] = Colors.white;
                                  newColor[2] = Colors.white;
                                  newColor[3] = Colors.white;
                                } else {
                                  newColor[1] = Colors.white;
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          CategoryIcon(
                            category: 'Pasta',
                            logo: pastaLogo,
                            boxColor: newColor[2],
                            onTap: () {
                              setState(() {
                                isButtonPressed[2] = !isButtonPressed[2];
                                if (isButtonPressed[2] == true) {
                                  newColor[2] = Colors.orange.shade400;
                                  isButtonPressed[0] = false;
                                  isButtonPressed[1] = false;
                                  isButtonPressed[3] = false;
                                  newColor[0] = Colors.white;
                                  newColor[1] = Colors.white;
                                  newColor[3] = Colors.white;
                                } else {
                                  newColor[2] = Colors.white;
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          CategoryIcon(
                            category: 'Wrap',
                            logo: wrapLogo,
                            boxColor: newColor[3],
                            onTap: () {
                              setState(() {
                                isButtonPressed[3] = !isButtonPressed[3];
                                if (isButtonPressed[3] == true) {
                                  newColor[3] = Colors.orange.shade400;
                                  isButtonPressed[0] = false;
                                  isButtonPressed[1] = false;
                                  isButtonPressed[2] = false;
                                  newColor[0] = Colors.white;
                                  newColor[1] = Colors.white;
                                  newColor[2] = Colors.white;
                                } else {
                                  newColor[3] = Colors.white;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Our Popular:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: _foodItems.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 240,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () async {
                                result = await Get.to(() => ItemDetails(
                                    documentId: documentSnapshot.id,
                                    items: items,
                                    quantity: quantity));
                                items = result[0];
                                quantity = result[1];
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 150,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Image.network(
                                            documentSnapshot['Image'],
                                            // height: 120,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        documentSnapshot['Name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        '- ${documentSnapshot['Description']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        'Rs. ${documentSnapshot['Price']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (streamSnapshot.hasError) {
                      return Center(
                          child: Text(streamSnapshot.error.toString()));
                    } else {
                      return const Center(child: Text('Something went wrong'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
