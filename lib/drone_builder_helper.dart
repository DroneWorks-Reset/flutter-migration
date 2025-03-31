import 'package:flutter/material.dart';

Widget droneBuilderBody(bool isUserLoggedIn, VoidCallback addToCart, Function selectPart, String selectedPart) {
 return Scaffold(
    body: Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          // Left Column: Customization Options (Scrollable)
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(right: 180), // Add right padding to leave space for the fixed right column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        color: Colors.black,
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          "Build Your Drone",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                    _buildOptionTile("Preconfigured Platforms", "Choose from pre-built drone models", selectedPart, selectPart),
                    _buildOptionTile("Frames", "Select a drone frame", selectedPart, selectPart),
                    _buildOptionTile("Accessories", "Add extra components", selectedPart, selectPart),
                    _buildOptionTile("Batteries", "Pick a long-lasting battery", selectedPart, selectPart),
                    _buildOptionTile("Camera Accessories", "Enhance your drone's camera capabilities", selectedPart, selectPart),
                    _buildOptionTile("ESCs", "Select electronic speed controllers", selectedPart, selectPart),
                    _buildOptionTile("Flight Controller", "Choose a flight controller", selectedPart, selectPart),
                    _buildOptionTile("GNSS Antenna", "Select a GNSS antenna", selectedPart, selectPart),
                    _buildOptionTile("LIDARs", "Add LIDAR sensors", selectedPart, selectPart),
                    _buildOptionTile("Lights", "Equip your drone with lights", selectedPart, selectPart),
                    _buildOptionTile("Motors", "Choose powerful motors", selectedPart, selectPart),
                    _buildOptionTile("Onboard Computer", "Select an onboard computer", selectedPart, selectPart),
                    _buildOptionTile("Parachutes", "Add safety parachutes", selectedPart, selectPart),
                    _buildOptionTile("Propellers", "Pick suitable propellers", selectedPart, selectPart),
                    _buildOptionTile("Radars & Sonars", "Equip your drone with radar and sonar systems", selectedPart, selectPart),
                    _buildOptionTile("Radio Receivers", "Choose a radio receiver", selectedPart, selectPart),
                    _buildOptionTile("Radio Transmitter", "Select a radio transmitter", selectedPart, selectPart),
                    _buildOptionTile("Range Finder", "Add a range finder", selectedPart, selectPart),
                  ],
                ),
              ),
          ),
              SizedBox(width: 20),
              // Right Column: 3D Preview Placeholder
         // Right Column: 3D Preview Placeholder and Add to Cart Button (Fixed in place)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 800, // Width of the right column
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildPartImage("path"),
                  SizedBox(height: 20), // Some space between the image and button
                  ElevatedButton(
                    onPressed: isUserLoggedIn ? addToCart : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text("Add to Cart"),
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

Widget _buildOptionTile(String title, String subtitle, String selectedPart, Function selectPart) {
  return 
  Container(
    width: 500,
    child: ListTile(
    
    leading: Icon(Icons.settings, color: Colors.blueAccent),
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
    tileColor: selectedPart == title ? Colors.blueAccent : Colors.transparent, // Highlight selected part
    onTap: () {
      selectPart(title); // Update selected part
    },
  ),
  );
  
}

Widget _buildPartImage(String part) {
  // You should replace the part images based on the selected part name
  String path = "assets/images/$part.png"; // Example image path
  return 
  
  Container(
    width: 500,
    height: 500,
    child: Image.asset(path),
  );
}
