import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Users");
  StreamSubscription<DatabaseEvent>? _cartSubscription;

  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _listenToCartChanges();
  }

  void _listenToCartChanges() {
    User? user = _auth.currentUser;
    if (user != null) {
      final cartRef = _database.child(user.email!.replaceAll('.', ',')).child('cart');
      _cartSubscription = cartRef.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        List<Map<String, dynamic>> items = [];
        double totalCost = 0.0;
        if (data != null && data is Map) {
          data.forEach((partCategory, partData) {
            if (partData is Map) {
              partData.forEach((itemName, itemDetails) {
                if (itemDetails is Map) {
                  double price = double.tryParse(itemDetails['price'].toString()) ?? 0.0;
                  int quantity = int.tryParse(itemDetails['quantity'].toString()) ?? 1;
                  totalCost += quantity * price;
                  items.add({
                    'part': partCategory,
                    'name': itemDetails['itemName'] ?? itemName,
                    'price': price,
                    'quantity': quantity,
                    'imageUrl': itemDetails['imageUrl'] ?? '',
                  });
                }
              });
            }
          });
        }
        if (mounted) {
          setState(() {
            cartItems = items;
            totalPrice = totalCost;
            isLoading = false;
          });
        }
      }, onError: (error) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        print("Error listening to cart changes: $error");
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateQuantity(Map<String, dynamic> item, int change) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userKey = user.email!.replaceAll('.', ',');
      String itemPath = "Users/$userKey/cart/${item['part']}/${item['name']}";
      final itemRef = FirebaseDatabase.instance.ref(itemPath);
      int updatedQty = item['quantity'] + change;
      if (updatedQty <= 0) {
        await itemRef.remove();
      } else {
        await itemRef.update({'quantity': updatedQty});
      }
    }
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  Widget buildCartItem(Map<String, dynamic> item) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
                    ? Image.network(
                        item['imageUrl'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      )
                    : Container(color: Colors.grey[800], child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40)),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Category: ${item['part']}", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 8),
                  Text(
                    "\$${(item['price'] as double).toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.white),
                  onPressed: () => updateQuantity(item, -1),
                ),
                Text("${item['quantity']}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.white),
                  onPressed: () => updateQuantity(item, 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text("Your Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    child: cartItems.isEmpty
                        ? Center(child: Text("Your cart is empty.", style: TextStyle(color: Colors.white, fontSize: 16)))
                        : ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return buildCartItem(item);
                            },
                          ),
                  ),
                  if (cartItems.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        border: Border(top: BorderSide(color: Colors.grey[800]!))
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(
                                "\$${totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Colors.green[800],
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout is not yet implemented.')));
                              },
                              child: Text("Proceed to Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}