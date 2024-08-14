import 'package:automated_food_ordering_system/src/features/core/screens/confirm_order/confirm_delivery_order.dart';
import 'package:automated_food_ordering_system/src/features/core/screens/confirm_order/confirm_dinein_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget {
  Cart(
      {Key? key,
      required this.itemId,
      required this.quantity,
      required this.orderType})
      : super(key: key);

  List<String> itemId;
  List<Map<String, int>> quantity;
  final String orderType;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final Map<String, int> _quantity = {};
  int _totalAmount = 0;
  int _amount = 0;

  final CollectionReference _foodItems =
      FirebaseFirestore.instance.collection('Food Items');

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

  @override
  Widget build(BuildContext context) {
    void addItem(String itemId) {
      setState(() {
        _quantity[itemId] = _quantity[itemId]! + 1;
        for (var i = 0; i < widget.quantity.length; i++) {
          var itemQuantity = widget.quantity[i];
          if (itemQuantity.containsKey(itemId)) {
            widget.quantity[i][itemId] = itemQuantity[itemId]! + 1;
            break;
          }
        }
      });
    }

    void removeItem(String itemId) {
      setState(() {
        if (_quantity[itemId]! > 1) {
          _quantity[itemId] = _quantity[itemId]! - 1;
          for (var i = 0; i < widget.quantity.length; i++) {
            var itemQuantity = widget.quantity[i];
            if (itemQuantity.containsKey(itemId)) {
              widget.quantity[i][itemId] = itemQuantity[itemId]! - 1;
              break;
            }
          }
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F7),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: widget.itemId.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : StreamBuilder(
                stream: _foodItems
                    .where(FieldPath.documentId, whereIn: widget.itemId)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    List<QueryDocumentSnapshot> orderedDocs = [
                      for (String id in widget.itemId)
                        streamSnapshot.data!.docs.firstWhere(
                            (doc) => doc.id == id,
                            orElse: () =>
                                throw ArgumentError('Invalid ID: $id'))
                    ];
                    _totalAmount = orderedDocs.fold(
                        0,
                        (sum, document) =>
                            sum +
                            int.parse(document['Price'] ?? '0') *
                                (_quantity[document.id] ?? 0));
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orderedDocs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = orderedDocs[index];
                                _amount = int.parse(document['Price'] ?? '0') *
                                    (_quantity[widget.itemId[index]] ?? 0);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 55,
                                              width: 55,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Image.network(
                                                    document['Image'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(document['Name']),
                                                  Text(
                                                    document['Description'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            Text(
                                              '$_amount',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  widget.itemId.removeAt(index);
                                                  widget.quantity
                                                      .removeAt(index);
                                                });
                                              },
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                child: const Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    removeItem(
                                                        widget.itemId[index]);
                                                  },
                                                  customBorder:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.orange),
                                                    child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 20),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  child: Text(
                                                    '${_quantity[widget.itemId[index]]}',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    addItem(
                                                        widget.itemId[index]);
                                                  },
                                                  customBorder:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.orange),
                                                    child: const Icon(Icons.add,
                                                        color: Colors.white,
                                                        size: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (widget.orderType == 'Delivery') {
                                      Get.to(() => ConfirmDeliveryOrder(
                                          itemId: widget.itemId,
                                          quantity: widget.quantity));
                                    }
                                    if (widget.orderType == 'DineIn') {
                                      Get.to(() => ConfirmDineInOrder(
                                          itemId: widget.itemId,
                                          quantity: widget.quantity));
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
                                        'Confirm Payment and Address\n Total Rs. $_totalAmount',
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
