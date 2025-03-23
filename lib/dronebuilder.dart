// import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Dronebuilder extends StatelessWidget {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign In with Google
  // Future<void> _signInWithGoogle(BuildContext context) async {
  //   try {
  //     // Trigger Google Sign In
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       // The user canceled the sign-in process
  //       return;
  //     }
      
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //     // Create a new credential for Firebase
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the credential
  //     await _auth.signInWithCredential(credential);
      
  //     // Show success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Signed in as ${googleUser.displayName}")),
  //     );
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Sign-in failed")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        Row(children: 
          [
            ElevatedButton(
              onPressed: (){
                  Navigator.pop(context);
            }, 
            
            child: 
              Text('Go back', 
                  //style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
            
                    //  ),
                  ),
              ),
          ],
        ),
        
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: 
              Row(children: [
                  Icon(Icons.login, color: Color.fromARGB(125, 255, 255, 255),),
                  Text("Sign in",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
              ],
              ),
             // Sign-In icon
            onPressed: () {
             // _signInWithGoogle(context); // Trigger Google Sign-In
            },
          ),
        ],
      ),
      body: _buildContactPage(),
    );
  }

  Widget _buildContactPage() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/contact_us_background.jpg', // Replace with your image path
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        
        // Black Box with White Text
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7), // Semi-transparent black box
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Address Section
                Text(
                  'Mississippi, Texas, USA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                
                // Email Section
                Text(
                  'ouremail@gmail.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                
                // Phone Number Section
                Text(
                  '+1 123 456 789',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                
                // Office Locations Section
                Text(
                  'Mississippi office',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                
                Text(
                  'Texas office',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                
                // Contact Button
                ElevatedButton(
                  onPressed: () {
                    // Implement navigation or functionality for the button
                  },
                  child: Text('Contact Us'),
                  style: ElevatedButton.styleFrom(
                  //  primary: Colors.blueAccent, // Customize button color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
