import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database

class Dronebuilder extends StatefulWidget {
  @override
  _DronebuilderState createState() => _DronebuilderState();
}

class _DronebuilderState extends State<Dronebuilder> {
  String signinText = "Login"; // Default sign-in button text
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  bool isUserLoggedIn = false; // Track login state
  int cartItemCount = 0; // Track cart item count
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Users"); // Realtime Database instance

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
        _database.child('Users').child(user.email!.replaceAll('.', ',')).child('cart').child('itemCount').onValue.listen((event) {
          if (event.snapshot.value != null) {
            setState(() {
              cartItemCount = event.snapshot.value as int;
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

      if (googleUser == null) {
        return null;
      }

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have successfully logged out.')),
      );
    } catch (e) {
      print("Error during sign-out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  void updateCart(int count) async {
    if (isUserLoggedIn) {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if 'cart' and 'itemCount' exist, if not, create them
        DatabaseReference userCartRef = _database.child(user.email!.replaceAll('.', ',')).child('cart');
        
        // Set itemCount, this will create cart and itemCount if they don't exist
        await userCartRef.set({
          'itemCount': count,
        }).then((_) {
          print("Cart updated successfully!");
        }).catchError((error) {
          print("Failed to update cart: $error");
        });
      }
    }
  }

  void addToCart() {
    setState(() {
      cartItemCount++;
    });
    updateCart(cartItemCount);
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
            ),
          ],
        ),
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
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        }
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
            icon: Row(
              children: [
                Icon(
                  Icons.login,
                  color: Color.fromARGB(125, 255, 255, 255),
                ),
                Text(
                  signinText,
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
            onPressed: () async {
              if (signinText == "Login") {
                User? user = await signInWithGoogle();
                if (user != null) {
                  setState(() {
                    signinText = "Logout";
                    isUserLoggedIn = true;
                  });
                  _fetchCartItemCount();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign in successful! \nWelcome ${user.displayName}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign in failed. Please try again.')),
                  );
                }
              } else {
                logout();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Content goes here"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUserLoggedIn ? addToCart : null,
              child: Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Center(child: Text("Your cart is empty.")),
    );
  }
}
