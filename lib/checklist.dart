import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ChecklistPage extends StatefulWidget {
  final VoidCallback onCheckout;
  const ChecklistPage({Key? key, required this.onCheckout}) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Users");
  StreamSubscription<DatabaseEvent>? _cartSubscription;

  bool isLoading = true;
  Map<String, dynamic> cartData = {};

  final Set<String> _criticalCategories = {
    'Frames',
    'Flight Controller',
    'ESCs',
    'Batteries',
    'Motors',
    'Propellers',
  };

  @override
  void initState() {
    super.initState();
    _listenToCartChanges();
  }

  void _listenToCartChanges() {
    User? user = _auth.currentUser;
    if (user != null) {
      final cartRef = _database.child(user.email!.replaceAll('.', ',')).child('cart');
      _cartSubscription = cartRef.onValue.listen((event) {
        if (mounted) {
          setState(() {
            cartData = event.snapshot.value != null
                ? Map<String, dynamic>.from(event.snapshot.value as Map)
                : {};
            isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateQuantity(String category, String itemName, int currentQuantity, int change) {
    User? user = _auth.currentUser;
    if (user != null) {
      final itemRef = _database.child(user.email!.replaceAll('.', ',')).child('cart').child(category).child(itemName);
      int newQuantity = currentQuantity + change;

      if (newQuantity <= 0) {
        itemRef.remove();
      } else {
        itemRef.update({'quantity': newQuantity});
      }
    }
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  Widget _buildPartDetailRow({
    required String categoryTitle,
    required Map<String, dynamic> itemDetails,
  }) {
    String name = itemDetails['itemName'] ?? 'Unknown Item';
    double price = double.tryParse(itemDetails['price'].toString()) ?? 0.0;
    int quantity = int.tryParse(itemDetails['quantity'].toString()) ?? 1;

    return Padding(
      padding: const EdgeInsets.only(left: 45.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.widgets_outlined, color: Colors.blueAccent, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("\$${price.toStringAsFixed(2)}", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.white),
                  onPressed: () => _updateQuantity(categoryTitle, name, quantity, -1),
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: () => _updateQuantity(categoryTitle, name, quantity, 1),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasReadyToFlyKit = cartData.containsKey("Preconfigured Platforms");
    List<String> missingItemsList = [];
    _criticalCategories.forEach((category) {
      if (!cartData.containsKey(category)) {
        missingItemsList.add(category);
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text("Drone Builder Checklist", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        if (hasReadyToFlyKit) ...[
                          _buildSectionHeader("Ready to Fly Kit"),
                          Builder(builder: (context) {
                            const categoryTitle = "Ready to Fly Kit";
                            const dataKey = "Preconfigured Platforms";
                            final categoryItems = cartData[dataKey] as Map;

                            return ExpansionTile(
                              key: PageStorageKey(categoryTitle),
                              initiallyExpanded: true,
                              leading: Icon(
                                Icons.check_circle,
                                color: Colors.cyan,
                              ),
                              title: Text(
                                categoryTitle,
                                style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              children: categoryItems.values.map((item) => _buildPartDetailRow(
                                        categoryTitle: dataKey,
                                        itemDetails: Map<String, dynamic>.from(item),
                                      )).toList(),
                            );
                          }),
                          Divider(color: Colors.grey[800], height: 30, thickness: 1, indent: 16, endIndent: 16),
                        ],
                        _buildSectionHeader("Build Your Drone Components"),
                        ..._criticalCategories.map((categoryTitle) {
                          final hasItems = cartData.containsKey(categoryTitle);
                          final categoryItems = hasItems ? cartData[categoryTitle] as Map : {};
                          
                          return ExpansionTile(
                            key: PageStorageKey(categoryTitle),
                            initiallyExpanded: hasItems,
                            leading: Icon(
                              hasItems ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: hasItems ? Colors.green : Colors.redAccent,
                            ),
                            title: Text(
                              categoryTitle,
                              style: TextStyle(color: hasItems ? Colors.green : Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            children: hasItems
                                ? categoryItems.values.map((item) => _buildPartDetailRow(
                                      categoryTitle: categoryTitle,
                                      itemDetails: Map<String, dynamic>.from(item),
                                    )).toList()
                                : [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 58.0, bottom: 15.0),
                                      child: Text("No ${categoryTitle.toLowerCase()} added yet.", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                                    )
                                  ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  
                  if (missingItemsList.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        border: Border(top: BorderSide(color: Colors.grey[800]!))
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, height: 1.5, fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'MISSING CRITICAL ITEMS: ',
                              style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: missingItemsList.join(', '),
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      color: Colors.black.withOpacity(0.8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onCheckout();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              "Ready to Checkout?",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}