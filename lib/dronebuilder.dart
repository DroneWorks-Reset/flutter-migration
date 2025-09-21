import 'package:droneworkz/drone_builder_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cart.dart'; // Assumes you have a cart.dart file for your CartPage widget

// This global variable holds the state for the selected part category.
String selectedPart = 'Preconfigured Platforms';

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
  bool _imagesPrecached = false; // Flag to ensure precaching runs only once

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images after initState and when context is available.
    if (!_imagesPrecached) {
      _precacheAllImages();
      _imagesPrecached = true;
    }
  }

  /// Loops through all items and downloads their images into the cache ahead of time.
  void _precacheAllImages() {
    print("Starting image precaching...");
    partDetails.forEach((category, items) {
      items.forEach((key, details) {
        final imageUrl = details['imageUrl'];
        if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != placeholderImageUrl) {
          precacheImage(NetworkImage(imageUrl), context);
        }
      });
    });
    print("Image precaching initiated.");
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
        // IMPORTANT: Using user.uid is the recommended best practice.
        final cartRef = _database.child(user.uid).child('cart');

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
          if (mounted) {
            setState(() {
              cartItemCount = total;
            });
          }
        });
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

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
      await GoogleSignIn().signOut(); // Also sign out from Google
      setState(() {
        signinText = "Login";
        isUserLoggedIn = false;
        cartItemCount = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have successfully logged out.')));
      }
    } catch (e) {
      print("Error during sign-out: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing out. Please try again.')));
      }
    }
  }

  void selectPart(String partName) {
    setState(() {
      selectedPart = partName;
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
        title: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back'),
            )
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          Stack(
            children: [
              Tooltip(
                message: isUserLoggedIn ? "Go to cart" : "Login first to save items in cart",
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: isUserLoggedIn ? Colors.white : Colors.grey),
                  onPressed: isUserLoggedIn ? openCartBottomSheet : null,
                ),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(
                      child: Text(
                        '$cartItemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          TextButton.icon(
            icon: Icon(Icons.login, color: Colors.white),
            label: Text(signinText, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (!isUserLoggedIn) {
                User? user = await signInWithGoogle();
                if (user != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in successful! Welcome ${user.displayName}')));
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in canceled or failed.')));
                }
              } else {
                logout();
              }
            },
          ),
        ],
      ),
      body: droneBuilderBody(isUserLoggedIn, selectedPart, selectPart),
    );
  }
}