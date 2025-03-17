import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
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
      return "0${index +1 } " + _pages[index]; // Show full title when active
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
                "DroneWorkz",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 700),
              ElevatedButton(
                onPressed: () {
                  _onNavItemTapped(_pages.indexOf('Hire Us'));
                },
                child: Text('Hire Us'),
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
            return _buildPageContent(index);
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

  Widget _buildPageContent(int index) {
    switch (_pages[index]) {
      case 'Home':
        return _buildHomePage();
      case 'Works':
        return _buildWorksPage();
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
    bool _isHovered = false;
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
                                _isHovered = isHovered;
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
                Text(
                    "Ajaya Dahal",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 700,),
                  Text(
                    "Aaron Uram",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorksPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selected Work',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            'S200 Model Powered by NXP flight controller',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Custom solution for autonomous flying partnered with best parts manufacturers like Gryphon Dynamics, PX4.',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Custom payloads - Camera, LiDAR. Your requirement; our support.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDroneBuilderPage() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Implement navigation to Drone Builder functionality
        },
        child: Text('Go to Drone Builder'),
      ),
    );
  }

  Widget _buildAboutPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'We believe in passionate people',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            '3D Model Designers',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Embedded Engineers',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Marketing',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContactPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Mississippi, Texas, USA',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            'ouremail@gmail.com',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            '+1 123 456 789',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Mississippi office',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Texas office',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement navigation to Contact Us functionality
            },
            child: Text('Contact Us'),
          ),
        ],
      ),
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
