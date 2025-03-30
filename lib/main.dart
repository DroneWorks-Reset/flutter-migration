import 'package:droneworkz/dronebuilder.dart';
import 'package:droneworkz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: ThemeData(  fontFamily:GoogleFonts.montserrat().fontFamily,),
    home: SideNav(),
  ));
}

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();  // Controller for PageView

  // List of navigation items
  final List<String> _pages = ['Home', 'Works', 'Drone Builder', 'About', 'Contact', 'Hire Us'];

  // Function to get the page name based on the index
  String _getPageTitle(int index) {
    if (index == _currentIndex) {
      return "0${index +1 } ${_pages[index]}"; // Show full title when active
    } else {
      return '0${index + 1}'; // Show number for inactive pages
    }
  }

  // Change the page when a nav item is clicked
  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);  // Switch the PageView to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/img/logo.png'),
              SizedBox(width: 10),
              Text(
                "DRONEWORKz",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 650),
              ElevatedButton(
                onPressed: () {
                  _onNavItemTapped(_pages.indexOf('Hire Us'));
                },
                child: Text('HIRE US'),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  print("Menu button pressed");
                },
              ),
            ],
          ),
        ),
      body: Row(
        children: [
          // Side Navigation
          Container(
            padding: EdgeInsets.all(20),  // Reduced padding for better spacing
            width: 250,
            color: const Color.fromARGB(255, 0, 0, 0),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                //shrinkWrap: true, // Prevents ListView from taking more space than necessary
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildNavItem(index);
                },
              ),
          ),
          // Main content - PageView for swipeable pages (vertical swipe)
    Expanded(
      child: Container(
        color: Colors.black, // Set background color to black
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          scrollDirection: Axis.vertical,  // Set scroll direction to vertical
          itemBuilder: (context, index) {
            return _buildPageContent(index, context);
          },
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;  // Update the current index on swipe
            });
          }
          ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index, BuildContext context) {
    switch (_pages[index]) {
      case 'Home':
        return _buildHomePage();
      case 'Works':
        return _buildWorksPage(context);
      case 'Drone Builder':
        return _buildDroneBuilderPage();
      case 'About':
        return _buildAboutPage();
      case 'Contact':
        return _buildContactPage();
      case 'Hire Us':
        return _buildHireUsPage();
      default:
        return Center(
          child: Text(
            "Page not found",
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _buildHomePage() {
    bool isHovered = false;
    return Center(
      child: 
      Padding(
        padding: EdgeInsets.all(30), // Add padding to the entire widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Banner Section
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(width: 15,),
                    Text(
                        'Your next\nUAV/UGV\nbuilders',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 68, // Adjusted to match the CSS font-size
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Montserrat',
                          height: 1, // line-height equivalent
                          letterSpacing: 0.5, // optional, to tweak letter spacing
                        ),
                      ),
                    SizedBox(height: 20),

                    ElevatedButton(
                        onPressed: () {
                          // Navigate to Hire Us page
                          _onNavItemTapped(_pages.indexOf('Hire Us'));
                        },

                         onHover: (isHovered) {
                              setState(() {
                                isHovered = isHovered;
                              });
                            },
                       style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return Color.fromARGB(255, 0, 0, 255);
                                        }
                                        return Color.fromARGB(170, 0, 0, 255); // Use the component's default.
                                      },
                                  ),
                                  //padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                                  padding: WidgetStateProperty.resolveWith<EdgeInsets?>(
                                      (Set<WidgetState> states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return EdgeInsets.all(30);
                                        }
                                        return EdgeInsets.all(20); // Use the component's default.
                                      },
                                  ),
                                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 15)),
                        ),
                      
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Hire Us', 
                                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)) 
                                ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),

                  ],
                ),
                SizedBox(height: 20, width: 200),
                Image.asset('assets/img/introduction-visual.png'), // Local image asset
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                Text(
                    "Ajaya Dahal\n",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Founder and System Software",
                    style: TextStyle(color: const Color.fromARGB(255, 223, 223, 223), fontSize: 12),
                  ),
               
                  ],
                ),

                SizedBox(width: 700,),
                
                Column(
                  children: [
                Text(
                    "Aaron Uram\n",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Founder and Frame Designer",
                    style: TextStyle(color: const Color.fromARGB(255, 223, 223, 223), fontSize: 12),
                  ),
               
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _currentIndexPic = 0;

  final List<Map<String, String>> imagesData = [
    {
      'image': 'assets/img/copter1.jpg',
      'title': 'S200 Model Powered by NXP flight controller',
      'description': 'Custom solution for autonomous flying partnered with best parts manufacturers like Gryphon Dynamics, PX4.'
    },
    {
      'image': 'assets/img/copter2.jpg',
      'title': 'Custom UAV Model',
      'description': 'Advanced systems for high-performance UAVs designed for various applications.'
    },
    {
      'image': 'assets/img/copter3.jpg',
      'title': 'Payload Customization',
      'description': 'Custom payloads such as Camera, LiDAR, tailored to your requirements.'
    },
  ];

  void _nextImage() {
    setState(() {
      if (_currentIndexPic < imagesData.length - 1) {
        _currentIndexPic++;
      } else {
        _currentIndexPic = 0; // Loop back to the first image
      }
    });
  }

  void _previousImage() {
    setState(() {
      if (_currentIndexPic> 0) {
        _currentIndexPic--;
      } else {
        _currentIndexPic= imagesData.length - 1; // Loop back to the last image
      }
    });
  }

 
 Widget _buildWorksPage(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SELECTED WORK',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left, color: Colors.white, size: 80),
              iconSize: 80,
              onPressed: _previousImage,
            ),
            SizedBox(width: 10),
            Expanded(
                child: SizedBox(
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (int i = 0; i < imagesData.length; i++)
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          left: (i == _currentIndexPic)
                              ? MediaQuery.of(context).size.width * 0.25
                              : (i == (_currentIndexPic + 1) % imagesData.length)
                                  ? MediaQuery.of(context).size.width * 0.5  // Adjusted to ensure the image stays within bounds
                                  : MediaQuery.of(context).size.width * 0.05,                          
                           
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: (i == _currentIndexPic) ? 300 : 200,
                              width: (i == _currentIndexPic) ? 300 : 200,
                              child: Image.asset(
                                imagesData[i]['image']!,
                                fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.arrow_right, color: Colors.white, size: 80),
              onPressed: _nextImage,
              iconSize: 80,
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          imagesData[_currentIndexPic]['title']!,
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          imagesData[_currentIndexPic]['description']!,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}




Widget _buildDroneBuilderPage() {
  bool isHovered = false;
  return Center(
    child: ElevatedButton(
      onPressed: () {
        // Implement navigation to Drone Builder functionality
        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dronebuilder()),
              );
      },
      onHover: (isHovered) {
               setState(() {
              isHovered = isHovered;
                              });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return Color.fromARGB(255, 0, 0, 255);
                                        }
                                        return Color.fromARGB(170, 0, 0, 255); // Use the component's default.
                                      },
                                      ),// Transparent background for gradient effect
        //elevation: WidgetStateProperty.resolveWith<EdgeInsets?>(0),  // Remove default shadow
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30),  // Rounded corners
        // ),
        padding: WidgetStateProperty.resolveWith<EdgeInsets?>(
                                      (Set<WidgetState> states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return EdgeInsets.all(30);
                                        }
                                        return EdgeInsets.all(20); // Use the component's default.
                                      },
                                  ),
        // side: BorderSide(color: Colors.blue, width: 2),  // Border color and thickness
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.grey],  // Gradient colors
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: 200, maxHeight: 60),  // Max size for button
          alignment: Alignment.center,
          child: Text(
            'Go to Drone Builder',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,  // Text color
            ),
          ),
        ),
      ),
    ),
  );
}

 Widget _buildAboutPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "We believe in passionate people" with Blue Dots and Image on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50,),
                // Left: Text with blue dots around it
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextWithBlueDots('We'),
                      Row(
                        children: [
                             _buildTextWithBlueDots('Believe in'),
                              SizedBox(width: 100,),
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.blue,
                                ),
                              ),

                        ],
                      ),
                      _buildTextWithBlueDots('Passionate'),
                      Row(
                        children: [
                             _buildTextWithBlueDots('People'),
                              SizedBox(width: 70,),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                              ),
                        ],
                      ),
                     
                    
                      SizedBox(height: 10,),

                      SizedBox(
                      height: 60,
                      width: 200,
                      child:  ElevatedButton(
                        onPressed: () {
                          // Add your button functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          //primary: Colors.blueAccent, // Customize button color
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                          
                        ),
                        child: Row(
                          children: [
                            Text('Career'),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right: Image next to the text
                Image.asset(
                  'assets/img/about-visual.png', // Replace with your image path
                  width: 400, // Adjust the size
                  height: 400, // Adjust the size
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 80,),
              ],
            ),
            SizedBox(height: 10),
            // Section for "3D Model Designers", "Embedded Engineers", and "Marketing"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50,),
                _buildRoleSection(
                  role: '3D MODEL DESIGNER',
                  imagePath: 'assets/img/about-winners.jpg', // Replace with your image path
                ),
                _buildRoleSection(
                  role: 'EMBEDDED ENGINEERS',
                  imagePath: 'assets/img/about-history.jpg', // Replace with your image path
                ),
                _buildRoleSection(
                  role: 'MARKETING',
                  imagePath: 'assets/img/about-philosophy.jpg', // Replace with your image path
                ),
                SizedBox(width: 50,),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'DroneWorkz.AI is a team of dedicated professionals focused on creating innovative solutions using cutting-edge drone technology. Our team is built on passion and creativity to bring you the future of 3D modeling, embedded engineering, and marketing.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }

  // Helper function to build text with blue dots around it
  Widget _buildTextWithBlueDots(String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w900,
            fontFamily: "Montserrat",
          ),
        ),
        SizedBox(width: 8),
 
      ],
    );
  }

  // Helper function for each role section
  Widget _buildRoleSection({required String role, required String imagePath}) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 100, // Set the width of the image
          height: 100, // Set the height of the image
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10),
        Text(
          role,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContactPage() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/img/contact-visual.png', // Replace with your image path
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        
        // Black Box with White Text
        SizedBox(height: 400, width: 400,),
        Center(
          
          child: Container(
            
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(120, 0, 0, 0), // Semi-transparent black box
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
                ElevatedButton(
                  onPressed: () {
                    // Implement navigation or functionality for the button
                  },
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.blueAccent, // Customize button color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Color.fromARGB(255, 0, 0, 255),
                  ),
                  child: Text('MISSISSIPPI OFFICE',
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                         ),
                  ),
              ),

                SizedBox(height: 10),
                
              ElevatedButton(
                  onPressed: () {
                    // Implement navigation or functionality for the button
                  },
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.blueAccent, // Customize button color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Color.fromARGB(255, 255, 0, 0),
                  ),
                 child: 
                    Text('TEXAS OFFICE', 
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                     ),
                  ),
              ),
                
                SizedBox(height: 20),
                
                // Contact Button
                ElevatedButton(
                  onPressed: () {
                    // Implement navigation or functionality for the button
                  },
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.blueAccent, // Customize button color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('CONTACT US'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 200,),
      ],
    );
  }

  Widget _buildHireUsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You want us to do',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            'Consultation',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Design guidance',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Full Package Drone Design',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement navigation to hiring process functionality
            },
            child: Text('Get in Touch'),
          ),
        ],
      ),
    );
  }
 

  Widget _buildNavItem(int index) {
  return ListTile(
    contentPadding: EdgeInsets.all(10),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [
        
        CircleAvatar(
          radius: 10,
          backgroundColor: _currentIndex == index
              ? const Color.fromARGB(255, 0, 0, 255)
              : Color.fromARGB(255, 190, 190, 190),
          
        ),
        SizedBox(width: 5),
        Column(
          children: [
              Text(
                _getPageTitle(index), 
                style: TextStyle(color:  _currentIndex == index 
                                  ? Color.fromARGB(255, 255, 255, 255) 
                                  : Color.fromARGB(255, 190, 190, 190)
                        ),
              ), 
              SizedBox(height: 5),
              Container(
                width: 150,
                height: 2,
                color: _currentIndex == index
                    ? const Color.fromARGB(255, 0, 0, 255)
                    : Color.fromARGB(255, 190, 190, 190)
                ),
                
          ],
        ),
        SizedBox(width: 5),
        CircleAvatar(
          radius: 10,
          backgroundColor: _currentIndex == index
              ? const Color.fromARGB(255, 0, 0, 255)
              : Color.fromARGB(255, 190, 190, 190),
        ),
        
        SizedBox(width: 15),

      ],
    ),
    onTap: () => _onNavItemTapped(index), // Handle tapping a nav item
  );
}

}
