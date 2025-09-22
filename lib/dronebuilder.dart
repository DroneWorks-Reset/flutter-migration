import 'package:droneworkz/drone_builder_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cart.dart';
import 'checklist.dart';

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
  bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      _precacheAllImages();
      _imagesPrecached = true;
    }
  }

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
    _auth.authStateChanges().listen((User? user) {
      if (!mounted) return;
      if (user == null) {
        setState(() {
          isUserLoggedIn = false;
          signinText = "Login";
          cartItemCount = 0;
        });
      } else {
        setState(() {
          isUserLoggedIn = true;
          signinText = "Logout";
        });
        _fetchCartItemCount();
      }
    });
  }

  void _fetchCartItemCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final cartRef = _database.child(user.email!.replaceAll('.', ',')).child('cart');
      cartRef.onValue.listen((event) {
        int total = 0;
        if (event.snapshot.exists && event.snapshot.value is Map) {
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
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
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

  void openCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(heightFactor: 0.85, child: CartPage()),
    );
  }

  void _openChecklistBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.85,
        child: ChecklistPage(onCheckout: openCartBottomSheet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Go back'))]),
        backgroundColor: Colors.black,
        actions: [
          Tooltip(
            message: "Drone Builder Checklist",
            child: IconButton(
              icon: Icon(Icons.checklist_rtl, color: Colors.white),
              onPressed: _openChecklistBottomSheet,
            ),
          ),
          Stack(
            alignment: Alignment.center,
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
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text(
                        '$cartItemCount',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
      body: DroneBuilderBody(isUserLoggedIn: isUserLoggedIn),
    );
  }
}