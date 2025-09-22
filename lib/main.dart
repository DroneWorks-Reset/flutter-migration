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
  runApp(const DroneWorkzApp());
}

class DroneWorkzApp extends StatelessWidget {
  const DroneWorkzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily),
      home: const SideNav(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  _SideNavState createState() => _SideNavState();
}
class _SideNavState extends State<SideNav> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isHovered = false;
  late final PageController _pageController;

  final List<String> _pages = ['Home', 'Works', 'Drone Builder', 'About', 'Contact', 'Hire Us'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void didChangeMetrics() {
    // Called when the window is resized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentIndex); // Force PageView to stay on current page
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Image.asset('assets/img/logo.png', height: 30),
                const SizedBox(width: 10),
                const Text("DRONEWORKz", style: TextStyle(color: Colors.white)),
                const Spacer(),
                if (constraints.maxWidth > 500)
                  ElevatedButton(
                    onPressed: () => _onNavItemTapped(_pages.indexOf('Hire Us')),
                    child: const Text('HIRE US'),
                  ),
                if (!isWide)
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (index) {
                      _onNavItemTapped(index);
                    },
                    itemBuilder: (context) => List.generate(_pages.length, (index) {
                      return PopupMenuItem<int>(
                        value: index,
                        child: Text(_pages[index]),
                      );
                    }),
                  ),
                if (isWide)
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => print("Menu button pressed"),
                  ),
              ],
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth >= 800
              ? _buildDesktopLayout()
              : _buildMobileLayout();
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 250,
          color: Colors.black,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _pages.length,
            itemBuilder: (context, index) => _buildNavItem(index),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.black,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => _buildPageContent(index),
              onPageChanged: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _pages.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => _buildPageContent(index),
      onPageChanged: (index) => setState(() => _currentIndex = index),
    );
  }

  // Widget _buildNavItem(int index) {
  //   return ListTile(
  //     title: Text(
  //       _getPageTitle(index),
  //       style: TextStyle(
  //         color: _currentIndex == index ? Colors.amber : Colors.white,
  //         fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
  //       ),
  //     ),
  //     onTap: () => _onNavItemTapped(index),
  //   );
  // }

  Widget _buildPageContent(int index) {
    switch (_pages[index]) {
      case 'Home':
        return _buildHomePage();
      case 'Works':
        return _buildWorksPage(context);
      case 'Drone Builder':
        return _buildDroneBuilderPage(context);
      case 'About':
        return _buildAboutPage();
      case 'Contact':
        return _buildContactPage();
      case 'Hire Us':
        return _buildHireUsPage();
      default:
        return const Center(
          child: Text("Page not found", style: TextStyle(color: Colors.white)),
        );
    }
  }
  Widget _buildHomePage() {
  final screenWidth = MediaQuery.of(context).size.width;

  // Determine if screen is small (mobile) or large (tablet/desktop)
  final isSmallScreen = screenWidth < 600;

  return Container(
  color: Colors.black,
  child: Center(
    child: SingleChildScrollView(  // prevent overflow vertically
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Banner Section - Column for small, Row for large
          isSmallScreen
              ? Column(
                  children: [
                    _buildBannerText(screenWidth),
                    const SizedBox(height: 20), // use height here for spacing in Column
                    Image.asset('assets/img/introduction-visual.png', width: screenWidth * 0.8), // limit image width
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: _buildBannerText(screenWidth)),
                    const SizedBox(width: 20), // reduce spacing from 200 to 20
                    Flexible(
                      child: Image.asset(
                        'assets/img/introduction-visual.png',
                        fit: BoxFit.contain,
                        width: screenWidth * 0.4, // limit image width to 40% of screen
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 40),

          // Founders section - Wrap for responsiveness
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 40,
            runSpacing: 20,
            children: [
              _buildFounderInfo("Ajaya Dahal", "Founder and System Software"),
              _buildFounderInfo("Aaron Uram", "Founder and Frame Designer"),
            ],
          ),
        ],
      ),
    ),
  ),
  );
}


Widget _buildBannerText(double screenWidth) {
  // Scale font size based on screen width (max 68)
  final fontSize = screenWidth < 600 ? 32.0 : 68.0;

  return Column(
    children: [
      Text(
        'Your next\nUAV/UGV\nbuilders',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: 'Montserrat',
          height: 1,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          _onNavItemTapped(_pages.indexOf('Hire Us'));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(MaterialState.hovered)) {
                return const Color.fromARGB(255, 0, 0, 255);
              }
              return const Color.fromARGB(170, 0, 0, 255);
            },
          ),
          padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
            (states) {
              if (states.contains(MaterialState.hovered)) {
                return const EdgeInsets.all(30);
              }
              return const EdgeInsets.all(20);
            },
          ),
          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Hire Us',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    ],
  );
}

Widget _buildFounderInfo(String name, String title) {
  return Column(
    children: [
      Text(
        "$name\n",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 223, 223, 223),
          fontSize: 12,
        ),
      ),
    ],
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
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final isSmallScreen = screenWidth < 900;
    final scrollController = ScrollController();

     if (isSmallScreen) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'SELECTED WORK',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded( // ✅ Make this expand to fill remaining space
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                scrollController.jumpTo(
                  scrollController.offset - details.delta.dy,
                );
              },
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.only(bottom: 20),
                itemCount: imagesData.length,
                separatorBuilder: (_, __) => SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[900],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                          child: Image.asset(
                            imagesData[index]['image']!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: double.infinity,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  imagesData[index]['title']!,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  imagesData[index]['description']!,
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Desktop / large screen version: original carousel
  final maxWidth = screenWidth * 0.8; // 80% width

  return Container(
    color: Colors.black,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SELECTED WORK',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: maxWidth,
          height: 320,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.white, size: 80),
                onPressed: _previousImage,
                iconSize: 80,
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (int i = 0; i < imagesData.length; i++)
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          left: (i == _currentIndexPic)
                              ? maxWidth * 0.25
                              : (i == (_currentIndexPic + 1) % imagesData.length)
                                  ? maxWidth * 0.5
                                  : maxWidth * 0.05,
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




Widget _buildDroneBuilderPage(BuildContext context) {
  return Container(
    color: Colors.black,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(16),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dronebuilder()),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(_isHovered && isDesktop ? 30 : 20),
              constraints: BoxConstraints(
                maxWidth: _isHovered && isDesktop ? 300 : 220,
                maxHeight: 80,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.grey],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Go to Drone Builder',
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}


Widget _buildAboutPage() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isWide = constraints.maxWidth > 800;

      return Container(
        color: Colors.black,  // Set black background everywhere
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section adapts for wide/narrow
                isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 50),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextWithBlueDots('We'),
                                Row(
                                  children: [
                                    _buildTextWithBlueDots('Believe in'),
                                    SizedBox(width: 100),
                                    Container(
                                      width: 75,
                                      height: 75,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                _buildTextWithBlueDots('Passionate'),
                                Row(
                                  children: [
                                    _buildTextWithBlueDots('People'),
                                    SizedBox(width: 70),
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
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 60,
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 12),
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
                          Image.asset(
                            'assets/img/about-visual.png',
                            width: 400,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 80),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          _buildTextWithBlueDots('We'),
                          _buildTextWithBlueDots('Believe in'),
                          _buildTextWithBlueDots('Passionate'),
                          _buildTextWithBlueDots('People'),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 60,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Career'),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/img/about-visual.png',
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),

                SizedBox(height: 20),

                // Roles section — horizontal row on wide, vertical scroll on narrow
                isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 50),
                          _buildRoleSection(
                            role: '3D MODEL DESIGNER',
                            imagePath: 'assets/img/about-winners.jpg',
                          ),
                          _buildRoleSection(
                            role: 'EMBEDDED ENGINEERS',
                            imagePath: 'assets/img/about-history.jpg',
                          ),
                          _buildRoleSection(
                            role: 'MARKETING',
                            imagePath: 'assets/img/about-philosophy.jpg',
                          ),
                          SizedBox(width: 50),
                        ],
                      )
                    : SizedBox(
                        height: 360, // Adjust height as needed for scrolling
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            _buildRoleSection(
                              role: '3D MODEL DESIGNER',
                              imagePath: 'assets/img/about-winners.jpg',
                            ),
                            SizedBox(height: 20),
                            _buildRoleSection(
                              role: 'EMBEDDED ENGINEERS',
                              imagePath: 'assets/img/about-history.jpg',
                            ),
                            SizedBox(height: 20),
                            _buildRoleSection(
                              role: 'MARKETING',
                              imagePath: 'assets/img/about-philosophy.jpg',
                            ),
                          ],
                        ),
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
        ),
      );
    },
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
    return 
    Container(
      color: Colors.black,
      child: Stack(
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
    ),
    );
  }

  Widget _buildHireUsPage() {
    return 
    Container(
      color: Colors.black,
      child: Center(
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
    ),
    );
  }
 

  Widget _buildNavItem(int index) {
  bool isSelected = _currentIndex == index;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: InkWell(
      onTap: () => _onNavItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '0${index + 1} ${_pages[index]}',
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  overflow: TextOverflow.ellipsis, // ← prevent text overflow
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
