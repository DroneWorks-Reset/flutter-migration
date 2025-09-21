import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

// The placeholder URL to be used for items without a specific image.
final String placeholderImageUrl = "https://cdn.pixabay.com/photo/2017/06/16/07/26/under-construction-2408061_1280.png";

// The complete, reordered product data map. It's a top-level variable for easy access.
final Map<String, Map<String, Map<String, String>>> partDetails = {
    "Preconfigured Platforms": {
      "pic1": {"name": "FPV Mosquito", "price": "1200", "description": "A versatile FPV quadcopter perfect for beginners and pros alike.", "imageUrl": placeholderImageUrl},
      "pic2": {"name": "Wise Owl", "price": "1800", "description": "High-performance hexacopter for heavy payloads.", "imageUrl": placeholderImageUrl},
    },
    "Frames": {
      "pic1": {
        "name": "Carbon Fiber Sheet: 200x300 mm, 2mm thick",
        "price": "50.49",
        "description": "A high-quality 3K carbon fiber sheet for custom drone frame construction.",
        "link": "https://www.getfpv.com/lumenier-3k-carbon-fiber-sheet-2mm-thick-200x300mm.html",
        "imageUrl": "https://cdn-v2.getfpv.com/media/catalog/product/cache/05bc89904627dbee2e1afef9cd2d4128/l/u/lumenier-qav-xs-stretch-fpv-racing-quadcopter_1_1_1_1_1_1_2.jpg"
      },
      "pic2": {"name": "Carbon X Frame", "price": "150", "description": "Lightweight carbon fiber frame for agility and strength.", "imageUrl": placeholderImageUrl},
      "pic3": {"name": "Titanium Heavy Frame", "price": "220", "description": "Durable frame for rugged conditions and heavy drones.", "imageUrl": placeholderImageUrl},
    },
    "Accessories": {
      "pic1": {"name": "EV800D FPV Goggles with DVR", "price": "108.99", "description": "5.8G 40CH 5-inch screen goggles with built-in DVR for an immersive FPV experience.", "link": "https://www.amazon.com/dp/B0CDLG441L", "imageUrl": "https://m.media-amazon.com/images/I/613qxlEHRDL._AC_SL1500_.jpg"},
      "pic2": {"name": "GoPro Camera Gimbal", "price": "68.13", "description": "A gimbal to stabilize your GoPro camera for smooth aerial video.", "link": "https://www.aliexpress.us/item/3256807390551452.html", "imageUrl": "https://m.media-amazon.com/images/I/41ZDXLXwLbL._UF894,1000_QL80_.jpg"},
      "pic3": { "name": "RC Telemetry kit: for Pixhawk Flight Controller", "price": "72.64", "description": "A telemetry radio set for establishing a connection between your flight controller and ground station.", "link": "https://www.amazon.com/dp/B0C4LBZGRG", "imageUrl": "https://m.media-amazon.com/images/I/61cmBHetThL._AC_SL1500_.jpg" },
      "pic4": { "name": "XT60 Plugs, Female and Male", "price": "10.99", "description": "High-quality XT60 connectors for secure battery and power connections.", "link": "https://www.amazon.com/dp/B0D93Q4BVK", "imageUrl": "https://m.media-amazon.com/images/I/719vPAjaaRL._AC_SL1500_.jpg" },
      "pic5": { "name": "XT60 to EC5 adapter", "price": "8.99", "description": "Adapter for connecting batteries with XT60 plugs to devices with EC5 connectors.", "link": "https://www.amazon.com/dp/B0CNGHYGM6", "imageUrl": "https://m.media-amazon.com/images/I/51uxEwkgS5L._AC_SL1300_.jpg" },
      "pic6": { "name": "Tenergy TB-6AB Battery Charger", "price": "39.99", "description": "A versatile balance charger for various types of LiPo, NiMH, and NiCD battery packs.", "link": "https://www.amazon.com/dp/B00466PKE0", "imageUrl": "https://m.media-amazon.com/images/I/71o4j9Xy8TL._AC_SL1500_.jpg" },
      "pic7": { "name": "Velcro Straps: Battery attachment", "price": "8.65", "description": "A pack of adjustable velcro straps for securely mounting batteries and other components.", "link": "https://www.amazon.com/Fastening-YiwerDer-Adjustable-Multi-Purpose-Organized/dp/B071DGMNMX/", "imageUrl": "https://m.media-amazon.com/images/I/71QBRf7JFtL._AC_SL1001_.jpg" },
    },
    "Batteries": {
      "pic1": {"name": "CNHL MiniStar 1500mAh 4s 120C Lipo", "price": "36.49", "description": "A high-discharge 4S LiPo battery, perfect for FPV racing and freestyle.", "link": "https://www.getfpv.com/cnhl-ministar-1500mah-4s-120c-lipo-battery.html", "imageUrl": "https://cdn-v2.getfpv.com/media/catalog/product/cache/6305596479836c3bfef8b369c2d05576/1/-/1-500x500.jpg"},
      "pic2": { "name": "Zeee 4s 5200 mAh 14.8V Lipo w/EC5 plug", "price": "89.09", "description": "High-capacity 5200mAh LiPo battery for extended flight times and high power output.", "link": "https://www.amazon.com/dp/B0B1DHNSKZ", "imageUrl": "https://m.media-amazon.com/images/I/7181rRXEX7L._AC_SL1500_.jpg" },
      "pic3": {"name": "Li-ion Smart Pack", "price": "110", "description": "Smart battery with built-in safety and diagnostics.", "imageUrl": placeholderImageUrl},
    },
    "Camera Accessories": {
      "pic1": {"name": "Caddx Ant 1200TVL Nano FPV Camera", "price": "20.99", "description": "A lightweight 14x14mm nano FPV camera with a 1.8mm lens for a wide field of view.", "link": "https://www.getfpv.com/caddx-ant-1200tvl-1-8mm-fpv-nano-camera-14x14-black.html", "imageUrl": "https://cdn-v2.getfpv.com/media/catalog/product/cache/6305596479836c3bfef8b369c2d05576/c/a/caddx_antcaddx-ant-main-low_res-width-1000px.jpg"},
      "pic2": { "name": "Sony ILX-LR1 Industrial Camera", "price": "2950.00", "description": "A full-frame interchangeable-lens camera designed for industrial applications and high-quality aerial photography.", "link": "https://www.amazon.com/Sony-ILX-LR1-Industrial-Interchangeable-Commercial/dp/B0CX9GTCJP", "imageUrl": "https://m.media-amazon.com/images/I/71g+nwUiy6L._AC_SL1500_.jpg" },
      "pic3": {"name": "FPV Camera Mount", "price": "75", "description": "Mount for first-person-view camera systems.", "imageUrl": placeholderImageUrl},
    },
    "ESCs": {
      "pic1": {"name": "AERO SELFIE H743 Flight Controller Stack", "price": "84.90", "description": "A 30x30 stack featuring an H743 FC and a 60A 8-bit 4-in-1 ESC.", "link": "https://www.amazon.com/dp/B0F9PGRHB4", "imageUrl": "https://m.media-amazon.com/images/I/71-Vrkzy6zL._AC_SL1500_.jpg"},
      "pic2": {"name": "32-bit Smart ESC", "price": "40", "description": "Advanced ESC with telemetry and protection features.", "imageUrl": placeholderImageUrl},
    },
    "Flight Controller": {
      "pic1": {"name": "AERO SELFIE H743 Flight Controller Stack", "price": "84.90", "description": "A 30x30 stack featuring an H743 FC and a 60A 8-bit 4-in-1 ESC.", "link": "https://www.amazon.com/dp/B0F9PGRHB4", "imageUrl": "https://m.media-amazon.com/images/I/71-Vrkzy6zL._AC_SL1500_.jpg"},
      "pic2": { "name": "Cube Orange+ Standard Set", "price": "385.00", "description": "An advanced flight controller for a wide range of autonomous vehicles, featuring a powerful H7 processor.", "link": "https://www.amazon.com/The-Cube-Orange-Standard-Set/dp/B0C8Y1LMGZ", "imageUrl": "https://m.media-amazon.com/images/I/31pwvYjGJ1L.jpg" },
      "pic3": { "name": "Cube Blue NDAA", "price": "600.00", "description": "An American-made, NDAA-compliant flight controller designed for government and commercial applications.", "link": "https://irlock.com/products/pixhawk2-1-blue-cube", "imageUrl": "https://irlock.com/cdn/shop/products/b01a.png?v=1656719250&width=1000" },
      "pic4": { "name": "Cube Red", "price": "1000.00", "description": "A flight controller designed for specialized applications requiring unique hardware configurations.", "link": "https://irlock.com/products/cube-red-standard-set-beta-version", "imageUrl": "https://irlock.com/cdn/shop/files/Cube_Red_Pro_Standard_Front.jpg?v=1732568923&width=1200" },
      "pic5": {"name": "Kakute F7", "price": "145", "description": "Compact and efficient flight control system.", "imageUrl": placeholderImageUrl},
    },
    "GNSS Antenna": {
      "pic1": { "name": "Here3+ GPS", "price": "225.00", "description": "A high-precision GNSS module with advanced navigation capabilities and an integrated compass.", "link": "https://www.amazon.com/CubePilot-Here3-with-iStand/dp/B0C8X6H68T", "imageUrl": "https://m.media-amazon.com/images/I/21xfUSVxjwS._AC_SX466_.jpg" },
      "pic2": { "name": "Here3+ Multiband RTK GNSS", "price": "350.00", "description": "An NDAA-compliant RTK GNSS module for centimeter-level positioning accuracy.", "link": "https://nwblue.com/", "imageUrl": "https://nwblue.com/cdn/shop/products/Here3_BasePackage-1_700x.jpg?v=1666239781" },
      "pic3": {"name": "U-blox Neo-M8N", "price": "60", "description": "Precision GPS module with excellent accuracy.", "imageUrl": placeholderImageUrl},
      "pic4": {"name": "Multi-band GNSS", "price": "95", "description": "Supports GPS, GLONASS, Galileo for improved coverage.", "imageUrl": placeholderImageUrl},
    },
    "LIDARs": { "pic1": {"name": "LIDAR Lite v4", "price": "170", "description": "Accurate distance sensing in compact form.", "imageUrl": placeholderImageUrl}, "pic2": {"name": "TF Mini Plus", "price": "110", "description": "Lightweight LIDAR for collision avoidance.", "imageUrl": placeholderImageUrl}, },
    "Lights": { "pic1": {"name": "LED Navigation Kit", "price": "30", "description": "Enhances visibility for orientation and safety.", "imageUrl": placeholderImageUrl}, "pic2": {"name": "Strobe Beacon", "price": "25", "description": "Ultra-bright strobe for visual tracking.", "imageUrl": placeholderImageUrl}, },
    "Motors": {
      "pic1": {"name": "Axisflying AE V2 2306.5 Motor", "price": "20.99", "description": "A high-performance 2306.5 motor, available in 1860KV or 1960KV.", "link": "https://www.getfpv.com/axisflying-ae-v2-2306-5-motor-1860kv-1960kv.html", "imageUrl": "https://cdn-v2.getfpv.com/media/catalog/product/cache/6305596479836c3bfef8b369c2d05576/a/x/axisflying_ae_v2_2306-5_motor_-_1860kv-1960kv-1.jpg"},
      "pic2": {"name": "Heavy Lift Motor 3510", "price": "65", "description": "Designed for lifting larger payloads.", "imageUrl": placeholderImageUrl},
      "pic3": { "name": "Readytosky 2205 2300KV Brushless Motor", "price": "35.99", "description": "A set of four 2300KV motors suitable for FPV quadcopters.", "link": "https://www.amazon.com/Readytosky-RS2205-2300KV-Brushless-Multicopter/dp/B088NGCZ64", "imageUrl": placeholderImageUrl },
      "pic4": { "name": "Holybro 2216 920 KV Motor", "price": "32.29", "description": "A set of four 920KV motors compatible with 1045 propellers, ideal for larger frames.", "link": "https://www.aliexpress.us/item/3256804376252643.html", "imageUrl": placeholderImageUrl },
      "pic5": { "name": "S500 compatible, 2212 920KV Motor", "price": "39.99", "description": "Brushless motors designed for Phantom and S500 style quadcopters.", "link": "https://www.amazon.com/Readytosky-Brushless-Motors-Phantom-Quadcopter/dp/B075DD16LK", "imageUrl": placeholderImageUrl },
      "pic6": { "name": "Motor Kit: motors, ESC, Propellers", "price": "55.99", "description": "A complete power combo kit including brushless motors, ESCs, and propellers for F450/F550 frames.", "link": "https://www.amazon.com/Brushless-Connector-Propeller-Helicopter-Quadcopter/dp/B0BW5H7Y8Q", "imageUrl": placeholderImageUrl },
    },
    "Onboard Computer": { "pic1": {"name": "Raspberry Pi 4", "price": "90", "description": "Ideal for real-time computing and AI tasks.", "imageUrl": placeholderImageUrl}, "pic2": {"name": "NVIDIA Jetson Nano", "price": "150", "description": "Powerful AI platform for edge computing on drones.", "imageUrl": placeholderImageUrl}, },
    "Parachutes": { "pic1": {"name": "Mini Recovery System", "price": "110", "description": "Deploys safely during emergency landings.", "imageUrl": placeholderImageUrl}, "pic2": {"name": "Auto-Deploy Parachute", "price": "180", "description": "Smart system for crash prevention.", "imageUrl": placeholderImageUrl}, },
    "Propellers": {
      "pic1": {"name": "Carbon Prop Set", "price": "35", "description": "Balanced for smooth and efficient thrust.", "imageUrl": placeholderImageUrl},
      "pic2": {"name": "Foldable Prop Blades", "price": "50", "description": "Space-saving and durable for portability.", "imageUrl": placeholderImageUrl},
      "pic3": { "name": "1045 Propellers for S500", "price": "44.60", "description": "A set of 10x4.5 propellers compatible with S500 frames and similar-sized drones.", "link": "https://www.aliexpress.us/item/2255800876580431.html", "imageUrl": placeholderImageUrl },
      "pic4": { "name": "SoloGood 1045 Propellers", "price": "13.99", "description": "A pack of 16 10x4.5 propellers for quadcopters and multirotors.", "link": "https://www.amazon.com/SoloGood-10x4-5-Propellers-Quadcopter-Multirotor/dp/B091KGR9Z6", "imageUrl": placeholderImageUrl },
    },
    "Radars & Sonars": { "pic1": {"name": "Ultrasonic Module", "price": "40", "description": "Detects obstacles using sonar waves.", "imageUrl": placeholderImageUrl}, "pic2": {"name": "Compact Radar Sensor", "price": "130", "description": "Detects objects in all weather conditions.", "imageUrl": placeholderImageUrl}, },
    "Radio Receivers": {
      "pic1": {"name": "RadioMaster RP1 ELRS Nano Receiver", "price": "19.99", "description": "A 2.4GHz ExpressLRS nano receiver with a T-antenna for reliable, long-range control.", "link": "https://www.amazon.com/dp/B0BZY2M4BS", "imageUrl": "https://m.media-amazon.com/images/I/41HL+w6G9TL._AC_SL1000_.jpg"},
      "pic2": {"name": "Crossfire Nano", "price": "60", "description": "Long-range receiver for extreme flights.", "imageUrl": placeholderImageUrl},
    },
    "Radio Transmitter": {
      "pic1": {"name": "RadioMaster Boxer Remote Controller", "price": "218.99", "description": "An EdgeTX 2.4G 16CH ELRS controller with AG01 Hall Gimbals for precise control.", "link": "https://www.amazon.com/dp/B0DLR7KCL5", "imageUrl": "https://m.media-amazon.com/images/I/51SC-Mu1NrL._AC_SL1000_.jpg"},
      "pic2": {"name": "Radiomaster TX16S", "price": "150", "description": "All-in-one transmitter with multi-protocol support.", "imageUrl": placeholderImageUrl},
      "pic3": { "name": "GoolRC Flysky 2.4G Transmitter/Receiver", "price": "74.99", "description": "A complete 2.4G 6-channel radio control system including both a transmitter and receiver.", "link": "https://www.amazon.com/dp/B08BC3VY11", "imageUrl": placeholderImageUrl },
      "pic4": { "name": "Blue Herelink Smart Controller", "price": "3699.00", "description": "An NDAA-compliant smart controller with an integrated screen and long-range HD video transmission.", "link": "https://nwblue.com/products/herelink-blue-v1-1", "imageUrl": placeholderImageUrl },
    },
    "Range Finder": { "pic1": {"name": "Laser Range Sensor", "price": "70", "description": "High-precision laser distance sensor.", "imageUrl": placeholderImageUrl}, "pic2": {"name": "Infrared Range Module", "price": "55", "description": "Affordable module for basic range sensing.", "imageUrl": placeholderImageUrl}, },
};
/// Defines the main two-column layout for the drone builder page.
Widget droneBuilderBody(bool isUserLoggedIn, String selectedPart, Function selectPart) {
  return Scaffold(
    body: Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, 
            child: SingleChildScrollView(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ Padding( padding: const EdgeInsets.symmetric(vertical: 16.0), 
                child: Text("Build Your Drone", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))), 
                ..._partList.map((part) => _buildOptionTile(part['title']!, part['subtitle']!, selectedPart, selectPart))]))),
          SizedBox(width: 20),
          Expanded(flex: 3, child: DroneImagePreview(isUserLoggedIn: isUserLoggedIn, selectedPart: selectedPart)),
        ],
      ),
    ),
  );
}

/// The list of data for the part selection menu on the left.
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
  return Container(width: 500, margin: const EdgeInsets.symmetric(vertical: 4), decoration: BoxDecoration(color: isSelected ? Colors.blueAccent : Colors.transparent, borderRadius: BorderRadius.circular(8)), child: ListTile(leading: Icon(Icons.settings, color: isSelected ? Colors.white : Colors.blueAccent.withOpacity(0.7)), title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white70)), subtitle: Text(subtitle, style: TextStyle(color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white60)), trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white), onTap: () => selectPart(title)));
}

class DroneImagePreview extends StatefulWidget {
  final bool isUserLoggedIn;
  final String selectedPart;

  DroneImagePreview({required this.isUserLoggedIn, required this.selectedPart});

  @override
  _DroneImagePreviewState createState() => _DroneImagePreviewState();
}

class _DroneImagePreviewState extends State<DroneImagePreview> {
  int currentIndex = 0;

  @override
  void didUpdateWidget(covariant DroneImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPart != oldWidget.selectedPart) {
      setState(() { currentIndex = 0; });
    }
  }

  void showPreviousImage() {
    final items = partDetails[widget.selectedPart]?.values.toList() ?? [];
    if (items.isEmpty) return;
    setState(() { currentIndex = (currentIndex - 1 + items.length) % items.length; });
  }

  void showNextImage() {
    final items = partDetails[widget.selectedPart]?.values.toList() ?? [];
    if (items.isEmpty) return;
    setState(() { currentIndex = (currentIndex + 1) % items.length; });
  }

  void handleAddToCart() async {
    if (!widget.isUserLoggedIn) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final db = FirebaseDatabase.instance.ref("Users");
    final partCategoryData = partDetails[widget.selectedPart];
    if (partCategoryData == null) return;
    final picKey = partCategoryData.keys.toList()[currentIndex];
    final detail = partCategoryData[picKey];
    if (detail != null) {
      final partRef = db.child(user.uid).child('cart').child(widget.selectedPart).child(detail['name']!);
      final snapshot = await partRef.get();
      int currentQuantity = 0;
      if (snapshot.exists && snapshot.child('quantity').value != null) {
        currentQuantity = int.tryParse(snapshot.child('quantity').value.toString()) ?? 0;
      }
      await partRef.set({'part': widget.selectedPart, 'itemName': detail['name'], 'price': detail['price'], 'description': detail['description'], 'link': detail['link'] ?? '', 'imageUrl': detail['imageUrl'] ?? '', 'quantity': currentQuantity + 1});
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $urlString');
    }
  }

  void _showNoUrlDialog() {
    showDialog(context: context, builder: (BuildContext context) { return AlertDialog(backgroundColor: Color.fromARGB(255, 40, 40, 40), title: Text("Link Not Available", style: TextStyle(color: Colors.white)), content: Text("A website link has not been provided for this part.", style: TextStyle(color: Colors.white70)), actions: <Widget>[TextButton(child: Text("OK"), onPressed: () => Navigator.of(context).pop())]);});
  }

  @override
  Widget build(BuildContext context) {
    final partCategoryData = partDetails[widget.selectedPart];
    if (partCategoryData == null || partCategoryData.isEmpty) {
      return Center(child: Text("No items available for this category.", style: TextStyle(color: Colors.white)));
    }
    final picKeys = partCategoryData.keys.toList();
    final picKey = picKeys[currentIndex];
    final detail = partCategoryData[picKey];
    final imageUrl = detail?['imageUrl'];
    final link = detail?['link'];

    Widget imageWidget;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      imageWidget = Image.network(imageUrl, fit: BoxFit.contain, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) { if (loadingProgress == null) return child; return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null));}, errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 48)));
    } else {
      imageWidget = Image.asset('img/${widget.selectedPart.toLowerCase().replaceAll(' ', '_')}/${picKey}.jpg', fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Center(child: Text('Image not found', style: TextStyle(color: Colors.white54))));
    }

    return Container(
      width: 800,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: showPreviousImage),
              InkWell(onTap: () { if (link != null && link.isNotEmpty) { _launchURL(link); } else { _showNoUrlDialog(); } }, child: Container(height: 500, width: 500, decoration: BoxDecoration(border: Border.all(color: Colors.redAccent, width: 2)), child: imageWidget)),
              IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: showNextImage),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(detail?['name'] ?? "Part Name", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(detail?['description'] ?? "Description not available", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "\$${detail?['price'] ?? 'N/A'}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          if (!widget.isUserLoggedIn)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text("Please login to add to cart.", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            ),
          ElevatedButton(
            onPressed: widget.isUserLoggedIn ? handleAddToCart : null,
            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            child: Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}