import 'package:droneworkz/drone_builder_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:google_sign_in/google_sign_in.dart'; 
import 'package:firebase_database/firebase_database.dart'; 
import 'cart.dart';

String selectedPart = 'Preconfigured Platforms'; // To store the selected part

class Dronebuilder extends StatefulWidget {
  @override
  _DronebuilderState createState() => _DronebuilderState();
}

class _DronebuilderState extends State<Dronebuilder> {
  String signinText = "Login";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUserLoggedIn = false;
  int cartItemCount = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Users");

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  void _checkUserLoginStatus() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        isUserLoggedIn = true;
        signinText = "Logout";
      });
      _fetchCartItemCount();
    }
  }

  void _fetchCartItemCount() async {
    if (isUserLoggedIn) {
      User? user = _auth.currentUser;
      if (user != null) {
        final cartRef = _database.child(user.email!.replaceAll('.', ',')).child('cart');

        cartRef.onValue.listen((event) {
          int total = 0;

          if (event.snapshot.value != null && event.snapshot.value is Map) {
            final items = Map<String, dynamic>.from(event.snapshot.value as Map);

            for (var part in items.values) {
              if (part is Map) {
                for (var item in part.values) {
                  if (item is Map && item.containsKey('quantity')) {
                    total += int.tryParse(item['quantity'].toString()) ?? 0;
                  }
                }
              }
            }
          }

          setState(() {
            cartItemCount = total;
          });
        });
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        setState(() {
          isUserLoggedIn = true;
          signinText = "Logout";
        });
        _fetchCartItemCount();
      }

      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        signinText = "Login";
        isUserLoggedIn = false;
        cartItemCount = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have successfully logged out.')));
    } catch (e) {
      print("Error during sign-out: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing out. Please try again.')));
    }
  }

  void addToCart() {
    setState(() {
      cartItemCount++;
    });
  }

  void selectPart(String partName) {
    setState(() {
      selectedPart = partName; // Update selected part
    });
  }

  void openCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.85,
        child: CartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text('Go back'))]),
        backgroundColor: Colors.black,
        actions: [
           Stack(
            children: [
              Tooltip(
                message: isUserLoggedIn ? "Go to cart" : "Login first to save items in cart",
                child: IconButton(
                  icon: Icon(Icons.shopping_cart,
                      color: isUserLoggedIn ? Colors.white : Colors.grey),
                  onPressed: isUserLoggedIn
                      ? openCartBottomSheet
                      : null,
                ),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Row(children: [Icon(Icons.login, color: Color.fromARGB(125, 255, 255, 255)), Text(signinText, style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))]),
            onPressed: () async {
              if (signinText == "Login") {
                User? user = await signInWithGoogle();
                if (user != null) {
                  setState(() {
                    signinText = "Logout";
                    isUserLoggedIn = true;
                  });
                  _fetchCartItemCount();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in successful! \nWelcome ${user.displayName}')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in failed. Please try again.')));
                }
              } else {
                logout();
              }
            },
          ),
        ],
      ),
      body: droneBuilderBody(isUserLoggedIn, addToCart, selectedPart, selectPart),
    );
  }
}
