import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/tracking_order/tracking_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ignore: must_be_immutable
class ConfirmDineInOrder extends StatefulWidget {
  ConfirmDineInOrder({super.key, required this.itemId, required this.quantity});

  final List<String> itemId;
  List<Map<String, int>> quantity;

  @override
  State<ConfirmDineInOrder> createState() => _ConfirmDineInOrderState();
}

class _ConfirmDineInOrderState extends State<ConfirmDineInOrder> {
  final Map<String, int> _quantity = {};
  int _amount = 0;
  int _subtotal = 0;
  int _totalAmount = 0;
  List<dynamic> result = [];
  List<String> tables = [
    'Table 01',
    'Table 02',
    'Table 03',
    'Table 04',
    'Table 05',
    'Table 11',
    'Table 12',
    'Table 13',
    'Table 14',
    'Table 15',
    'Table 21',
    'Table 22',
    'Table 23',
    'Table 24',
    'Table 25',
  ];
  String? selectedTable = '';

  final CollectionReference _foodItems =
  FirebaseFirestore.instance.collection('Food Items');
  final CollectionReference _placedOrder =
  FirebaseFirestore.instance.collection('Orders');

  final controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    for (var id in widget.itemId) {
      for (var i = 0; i < widget.quantity.length; i++) {
        var itemQuantity = widget.quantity[i];
        if (itemQuantity.containsKey(id)) {
          _quantity[id] = itemQuantity[id]!;
          break;
        }
      }
    }
  }

  void updateSelectedTable(String table) {
    setState(() {
      selectedTable = table;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: const Text('Checkout'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _foodItems
              .where(FieldPath.documentId, whereIn: widget.itemId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              List<QueryDocumentSnapshot> orderedDocs = [
                for (String id in widget.itemId)
                  streamSnapshot.data!.docs.firstWhere((doc) => doc.id == id,
                      orElse: () => throw ArgumentError('Invalid ID: $id'))
              ];
              _subtotal = orderedDocs.fold(
                  0,
                      (sum, document) =>
                  sum +
                      int.parse(document['Price'] ?? '0') *
                          (_quantity[document.id] ?? 0));
              _totalAmount = _subtotal;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Ink(
                              height: 350,
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F5F7),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: tables.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        updateSelectedTable(tables[index]);
                                        Navigator.pop(context);
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Ink(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.02),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          tables[index],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Ink(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: Center(
                          child: Text(
                            selectedTable != ''
                                ? 'Selected table: $selectedTable'
                                : 'Select table',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
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
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: widget.itemId.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot document =
                                      orderedDocs[index];
                                      _amount = int.parse(
                                          document['Price'] ?? '0') *
                                          (_quantity[widget.itemId[index]] ??
                                              0);
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      child: Text(
                                                          "${_quantity[widget
                                                              .itemId[index]]}x"),
                                                    ),
                                                    Text(document['Name']),
                                                  ],
                                                ),
                                                Text("Rs. $_amount"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Divider(color: Colors.black.withOpacity(0.2)),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Subtotal:'),
                                            Text('Rs. $_subtotal'),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Delivery:'),
                                            Text('Rs. 0'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: controller.getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          UserModel user = snapshot.data as UserModel;
                          final id = TextEditingController(text: user.id);
                          return Container(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (selectedTable!.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                titlePadding:
                                                const EdgeInsets.only(top: 20),
                                                contentPadding:
                                                const EdgeInsets.only(
                                                    top: 10,
                                                    right: 10,
                                                    left: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(25.0),
                                                ),
                                                title: const Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: 70),
                                                content: const Text(
                                                  "Please select table",
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  Center(
                                                    child: TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("OK"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      } else {
                                        _placedOrder.add({
                                          'User ID': id.text,
                                          'Item ID': widget.itemId,
                                          'Quantity': widget.quantity,
                                          'Table': selectedTable,
                                        });
                                        Get.offAll(const TrackingOrder());
                                      }
                                    },
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Place Order\n Total Rs. $_totalAmount',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return const Center(
                              child: Text('Something went wrong'));
                        }
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
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
