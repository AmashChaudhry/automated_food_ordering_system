import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key, required this.documentId, required this.items, required this.quantity})
      : super(key: key);

  final String documentId;
  final List<String> items;
  final List<Map<String, int>> quantity;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  String selectedValue = '';
  final Map<String, double> _selectedItems = {};
  int _quantity = 1;
  int amount = 0;
  int extraItemPrice = 0;
  List<String> items = [];
  List<Map<String, int>> quantity = [];

  final CollectionReference _foodItems =
      FirebaseFirestore.instance.collection('Food Items');

  @override
  Widget build(BuildContext context) {
    items = widget.items;
    quantity = widget.quantity;

    void addItem() {
      setState(() {
        _quantity++;
      });
    }

    void removeItem() {
      setState(() {
        if (_quantity > 1) {
          _quantity--;
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: StreamBuilder(
          stream: _foodItems.doc(widget.documentId).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              amount = (int.parse(streamSnapshot.data!.get('Price')) * _quantity) +
                      extraItemPrice;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 350,
                            width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Image.network(
                                  streamSnapshot.data!.get('Image'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(streamSnapshot.data!.get('Name'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    Text(
                                      'Rs. ${streamSnapshot.data!.get('Price')}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(streamSnapshot.data!.get('Description'),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3),
                                Divider(color: Colors.black.withOpacity(0.2)),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Center(
                                            child: Text('Choose one',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: const Text(
                                              'Required',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      RadioListTile(
                                        title: Text('Coca-Cola - 345 ml',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        value: 'Coca-Cola',
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              selectedValue = value!;
                                            },
                                          );
                                        },
                                        secondary: const Text('Free'),
                                      ),
                                      RadioListTile(
                                        title: Text('Mirinda - 345 ml',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        value: 'Mirinda',
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              selectedValue = value!;
                                            },
                                          );
                                        },
                                        secondary: const Text('Free'),
                                      ),
                                      RadioListTile(
                                        title: Text('Sprite - 345 ml',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        value: 'Sprite',
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              selectedValue = value!;
                                            },
                                          );
                                        },
                                        secondary: const Text('Free'),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: Colors.black.withOpacity(0.2)),
                                Text('Frequently bought together',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _selectedItems
                                                .containsKey('Extra Sauce'),
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  if (value!) {
                                                    _selectedItems[
                                                        'Extra Sauce'] = 45;
                                                    extraItemPrice =
                                                        extraItemPrice + 45;
                                                  } else {
                                                    _selectedItems
                                                        .remove('Extra Sauce');
                                                    extraItemPrice =
                                                        extraItemPrice - 45;
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Extra Sauce'),
                                          ),
                                          const Text('+ Rs. 45'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _selectedItems
                                                .containsKey('Cheese Slice'),
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  if (value!) {
                                                    _selectedItems[
                                                        'Cheese Slice'] = 55;
                                                    extraItemPrice =
                                                        extraItemPrice + 55;
                                                  } else {
                                                    _selectedItems
                                                        .remove('Cheese Slice');
                                                    extraItemPrice =
                                                        extraItemPrice - 55;
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Cheese Slice'),
                                          ),
                                          const Text('+ Rs. 55'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _selectedItems
                                                .containsKey('Coleslaw'),
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  if (value!) {
                                                    _selectedItems['Coleslaw'] =
                                                        80;
                                                    extraItemPrice =
                                                        extraItemPrice + 80;
                                                  } else {
                                                    _selectedItems
                                                        .remove('Coleslaw');
                                                    extraItemPrice =
                                                        extraItemPrice - 80;
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Coleslaw'),
                                          ),
                                          const Text('+ Rs. 80'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _selectedItems
                                                .containsKey('Chicken Piece'),
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  if (value!) {
                                                    _selectedItems[
                                                        'Chicken Piece'] = 220;
                                                    extraItemPrice =
                                                        extraItemPrice + 220;
                                                  } else {
                                                    _selectedItems.remove(
                                                        'Chicken Piece');
                                                    extraItemPrice =
                                                        extraItemPrice - 220;
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Chicken Piece'),
                                          ),
                                          const Text('+ Rs. 220'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _selectedItems
                                                .containsKey('Snack Bucket'),
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  if (value!) {
                                                    _selectedItems[
                                                        'Snack Bucket'] = 490;
                                                    extraItemPrice =
                                                        extraItemPrice + 490;
                                                  } else {
                                                    _selectedItems
                                                        .remove('Snack Bucket');
                                                    extraItemPrice =
                                                        extraItemPrice - 490;
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          const Expanded(
                                            child: Text('Snack Bucket'),
                                          ),
                                          const Text('+ Rs. 490'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            removeItem();
                            if (amount >
                                int.parse(streamSnapshot.data!.get('Price'))) {
                              amount = amount -
                                  int.parse(streamSnapshot.data!.get('Price'));
                            }
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.orange),
                            child:
                                const Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            '$_quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            addItem();
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.orange),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (items.contains(streamSnapshot.data!.id)) {
                                // _quantity++;
                              } else {
                                items.add(streamSnapshot.data!.id);
                              }
                              Map<String, int> quantityWithId = {streamSnapshot.data!.id: _quantity};
                              if (quantity.any((element) => element.containsKey(streamSnapshot.data!.id))) {
                                for (int i = 0; i < quantity.length; i++) {
                                  if (quantity[i].containsKey(streamSnapshot.data!.id)) {
                                    quantity[i][streamSnapshot.data!.id] = quantity[i][streamSnapshot.data!.id]! + _quantity;
                                    break;
                                  }
                                }
                              } else {
                                quantity.add(quantityWithId);
                              }
                              Get.back(result: [items, quantity]);
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
                                  'Add to cart\n Rs. $amount',
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
