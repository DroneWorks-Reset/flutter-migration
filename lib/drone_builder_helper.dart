import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Widget droneBuilderBody(bool isUserLoggedIn, VoidCallback addToCart, String selectedPart, Function selectPart) {
  return Scaffold(
    body: Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Scrollable Part Options
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Build Your Drone",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._partList.map((part) => _buildOptionTile(part['title']!, part['subtitle']!, selectedPart, selectPart)),
                ],
              ),
            ),
          ),

          SizedBox(width: 20),

          // Right Column: Image Viewer and Button
          Expanded(
            flex: 3,
            child: DroneImagePreview(
              isUserLoggedIn: isUserLoggedIn,
              addToCart: addToCart,
              selectedPart: selectedPart,
            ),
          ),
        ],
      ),
    ),
  );
}

final List<Map<String, String>> _partList = [
  {"title": "Preconfigured Platforms", "subtitle": "Choose from pre-built drone models"},
  {"title": "Frames", "subtitle": "Select a drone frame"},
  {"title": "Accessories", "subtitle": "Add extra components"},
  {"title": "Batteries", "subtitle": "Pick a long-lasting battery"},
  {"title": "Camera Accessories", "subtitle": "Enhance your drone's camera capabilities"},
  {"title": "ESCs", "subtitle": "Select electronic speed controllers"},
  {"title": "Flight Controller", "subtitle": "Choose a flight controller"},
  {"title": "GNSS Antenna", "subtitle": "Select a GNSS antenna"},
  {"title": "LIDARs", "subtitle": "Add LIDAR sensors"},
  {"title": "Lights", "subtitle": "Equip your drone with lights"},
  {"title": "Motors", "subtitle": "Choose powerful motors"},
  {"title": "Onboard Computer", "subtitle": "Select an onboard computer"},
  {"title": "Parachutes", "subtitle": "Add safety parachutes"},
  {"title": "Propellers", "subtitle": "Pick suitable propellers"},
  {"title": "Radars & Sonars", "subtitle": "Equip your drone with radar and sonar systems"},
  {"title": "Radio Receivers", "subtitle": "Choose a radio receiver"},
  {"title": "Radio Transmitter", "subtitle": "Select a radio transmitter"},
  {"title": "Range Finder", "subtitle": "Add a range finder"},
];

Widget _buildOptionTile(String title, String subtitle, String selectedPart, Function selectPart) {
  final bool isSelected = selectedPart == title;
  return Container(
    width: 500,
    child: ListTile(
      leading: Icon(Icons.settings, color: isSelected ? Colors.white : Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white60),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      tileColor: isSelected ? Colors.blueAccent : Colors.transparent,
      onTap: () {
        selectPart(title);
      },
    ),
  );
}

class DroneImagePreview extends StatefulWidget {
  final bool isUserLoggedIn;
  final VoidCallback addToCart;
  final String selectedPart;

  DroneImagePreview({required this.isUserLoggedIn, required this.addToCart, required this.selectedPart});

  @override
  _DroneImagePreviewState createState() => _DroneImagePreviewState();
}

class _DroneImagePreviewState extends State<DroneImagePreview> {
  int currentIndex = 0;
  final Map<String, Map<String, Map<String, String>>> partDetails = {
  "Preconfigured Platforms": {
    "pic1": {"name": "QuadCopter Alpha", "price": "1200", "description": "A versatile quadcopter perfect for beginners and pros alike."},
    "pic2": {"name": "HexaCopter X", "price": "1800", "description": "High-performance hexacopter for heavy payloads."},
  },
  "Frames": {
    "pic1": {"name": "Carbon X Frame", "price": "150", "description": "Lightweight carbon fiber frame for agility and strength."},
    "pic2": {"name": "Titanium Heavy Frame", "price": "220", "description": "Durable frame for rugged conditions and heavy drones."},
  },
  "Accessories": {
    "pic1": {"name": "Landing Gear Set", "price": "45", "description": "Provides stable landing for any terrain."},
    "pic2": {"name": "Protective Shell", "price": "60", "description": "Shields internal components from damage and weather."},
  },
  "Batteries": {
    "pic1": {"name": "LiPo 4S 5200mAh", "price": "80", "description": "Reliable battery for extended flight times."},
    "pic2": {"name": "Li-ion Smart Pack", "price": "110", "description": "Smart battery with built-in safety and diagnostics."},
  },
  "Camera Accessories": {
    "pic1": {"name": "Gimbal Stabilizer", "price": "130", "description": "Keeps your camera steady during flight."},
    "pic2": {"name": "FPV Camera Mount", "price": "75", "description": "Mount for first-person-view camera systems."},
  },
  "ESCs": {
    "pic1": {"name": "BLHeli 30A ESC", "price": "25", "description": "High-speed ESC for smooth motor control."},
    "pic2": {"name": "32-bit Smart ESC", "price": "40", "description": "Advanced ESC with telemetry and protection features."},
  },
  "Flight Controller": {
    "pic1": {"name": "Pixhawk 4", "price": "210", "description": "Open-source controller with rich features."},
    "pic2": {"name": "Kakute F7", "price": "145", "description": "Compact and efficient flight control system."},
  },
  "GNSS Antenna": {
    "pic1": {"name": "U-blox Neo-M8N", "price": "60", "description": "Precision GPS module with excellent accuracy."},
    "pic2": {"name": "Multi-band GNSS", "price": "95", "description": "Supports GPS, GLONASS, Galileo for improved coverage."},
  },
  "LIDARs": {
    "pic1": {"name": "LIDAR Lite v4", "price": "170", "description": "Accurate distance sensing in compact form."},
    "pic2": {"name": "TF Mini Plus", "price": "110", "description": "Lightweight LIDAR for collision avoidance."},
  },
  "Lights": {
    "pic1": {"name": "LED Navigation Kit", "price": "30", "description": "Enhances visibility for orientation and safety."},
    "pic2": {"name": "Strobe Beacon", "price": "25", "description": "Ultra-bright strobe for visual tracking."},
  },
  "Motors": {
    "pic1": {"name": "Brushless Motor 2207", "price": "45", "description": "High-efficiency motor for racing drones."},
    "pic2": {"name": "Heavy Lift Motor 3510", "price": "65", "description": "Designed for lifting larger payloads."},
  },
  "Onboard Computer": {
    "pic1": {"name": "Raspberry Pi 4", "price": "90", "description": "Ideal for real-time computing and AI tasks."},
    "pic2": {"name": "NVIDIA Jetson Nano", "price": "150", "description": "Powerful AI platform for edge computing on drones."},
  },
  "Parachutes": {
    "pic1": {"name": "Mini Recovery System", "price": "110", "description": "Deploys safely during emergency landings."},
    "pic2": {"name": "Auto-Deploy Parachute", "price": "180", "description": "Smart system for crash prevention."},
  },
  "Propellers": {
    "pic1": {"name": "Carbon Prop Set", "price": "35", "description": "Balanced for smooth and efficient thrust."},
    "pic2": {"name": "Foldable Prop Blades", "price": "50", "description": "Space-saving and durable for portability."},
  },
  "Radars & Sonars": {
    "pic1": {"name": "Ultrasonic Module", "price": "40", "description": "Detects obstacles using sonar waves."},
    "pic2": {"name": "Compact Radar Sensor", "price": "130", "description": "Detects objects in all weather conditions."},
  },
  "Radio Receivers": {
    "pic1": {"name": "FrSky X8R", "price": "45", "description": "Reliable 8-channel telemetry receiver."},
    "pic2": {"name": "Crossfire Nano", "price": "60", "description": "Long-range receiver for extreme flights."},
  },
  "Radio Transmitter": {
    "pic1": {"name": "Taranis QX7", "price": "110", "description": "Feature-rich transmitter with OpenTX."},
    "pic2": {"name": "Radiomaster TX16S", "price": "150", "description": "All-in-one transmitter with multi-protocol support."},
  },
  "Range Finder": {
    "pic1": {"name": "Laser Range Sensor", "price": "70", "description": "High-precision laser distance sensor."},
    "pic2": {"name": "Infrared Range Module", "price": "55", "description": "Affordable module for basic range sensing."},
  },
  };

  void showPreviousImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + 2) % 2;
    });
  }

  void showNextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % 2;
    });
  }

  void handleAddToCart() async {
    if (!widget.isUserLoggedIn) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final db = FirebaseDatabase.instance.ref("Users");
    final part = widget.selectedPart;
    final picKey = currentIndex == 0 ? "pic1" : "pic2";
    final detail = partDetails[part]?[picKey];

      if (detail != null) {
    final partRef = db.child(user.email!.replaceAll('.', ',')).child('cart').child(part).child(detail['name']!);
    final snapshot = await partRef.get();

    int currentQuantity = 0;
    if (snapshot.exists && snapshot.child('quantity').value != null) {
      currentQuantity = int.tryParse(snapshot.child('quantity').value.toString()) ?? 0;
    }

    await partRef.set({
      'part': part,
      'itemName': detail['name'],
      'price': detail['price'],
      'description': detail['description'],
      'quantity': currentQuantity + 1,
    });
  }

  }

  @override
  Widget build(BuildContext context) {
    final part = widget.selectedPart;
    final picKey = currentIndex == 0 ? "pic1" : "pic2";
    final detail = partDetails[part]?[picKey];
    final imagePath = 'img/${part.toLowerCase().replaceAll(' ', '_')}/${picKey}.jpg';

    return Container(
      width: 800,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: showPreviousImage,
              ),
              Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: showNextImage,
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            detail?['description'] ?? "Description not available",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.isUserLoggedIn ? handleAddToCart : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}
