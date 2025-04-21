import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Users");

  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  int totalQuantity = 0;
  int totalPrice = 0;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final cartRef = _database.child(user.email!.replaceAll('.', ',')).child('cart');

      cartRef.once().then((DatabaseEvent event) {
        final data = event.snapshot.value;

        List<Map<String, dynamic>> items = [];
        int totalQty = 0;
        int totalCost = 0;

        if (data != null && data is Map) {
          data.forEach((partCategory, partData) {
            if (partData is Map) {
              partData.forEach((itemName, itemDetails) {
                if (itemDetails is Map) {
                  int quantity = int.tryParse(itemDetails['quantity'].toString()) ?? 1;
                  int price = int.tryParse(itemDetails['price'].toString()) ?? 0;

                  totalQty += quantity;
                  totalCost += quantity * price;

                  items.add({
                    'part': partCategory,
                    'name': itemDetails['itemName'] ?? itemName,
                    'description': itemDetails['description'] ?? '',
                    'price': price,
                    'quantity': quantity,
                  });
                }
              });
            }
          });
        }

        setState(() {
          cartItems = items;
          totalQuantity = totalQty;
          totalPrice = totalCost;
          isLoading = false;
        });
      });
    }
  }

  void updateQuantity(Map<String, dynamic> item, int change, int index) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userKey = user.email!.replaceAll('.', ',');
      String itemPath = "Users/$userKey/cart/${item['part']}/${item['name']}";
      final itemRef = FirebaseDatabase.instance.ref(itemPath);
      final snapshot = await itemRef.get();

      if (snapshot.exists) {
        int updatedQty = item['quantity'] + change;

        if (updatedQty <= 0) {
          final removedItem = cartItems.removeAt(index);
          _listKey.currentState!.removeItem(
            index,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: buildCartItem(removedItem, index),
            ),
            duration: Duration(milliseconds: 300),
          );
          await itemRef.remove();
        } else {
          await itemRef.update({'quantity': updatedQty});
          setState(() {
            cartItems[index]['quantity'] = updatedQty;
          });
        }
        recalculateTotals();
      }
    }
  }

  void recalculateTotals() {
    int qty = 0;
    int cost = 0;
    for (var item in cartItems) {
  qty += (item['quantity'] as num).toInt();
      cost += (item['price'] as num).toInt() * (item['quantity'] as num).toInt();
    }
    setState(() {
      totalQuantity = qty;
      totalPrice = cost;
    });
  }

  Widget buildCartItem(Map<String, dynamic> item, int index) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(item['name'], style: TextStyle(color: Colors.white)),
              subtitle: Text(
                "${item['description']}\nCategory: ${item['part']}",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () => updateQuantity(item, -1, index),
                ),
                Text("${item['quantity']}", style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => updateQuantity(item, 1, index),
                ),
                SizedBox(width: 12),
                Text("\$${item['price']}",
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                SizedBox(width: 12),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Cart", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Text(
                            "Your cart is empty.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : AnimatedList(
                          key: _listKey,
                          initialItemCount: cartItems.length,
                          itemBuilder: (context, index, animation) {
                            final item = cartItems[index];
                            return SizeTransition(
                              sizeFactor: animation,
                              child: buildCartItem(item, index),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        color: Colors.grey[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Items: $totalQuantity",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "Total: \$$totalPrice",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        color: Colors.black,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Redirecting to payment...')),
                            );
                          },
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
