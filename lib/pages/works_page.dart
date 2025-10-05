import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; // Import the async library for Timer

class WorksPage extends StatefulWidget {
  const WorksPage({super.key});

  @override
  State<WorksPage> createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoplayTimer; // Timer for the autoplay functionality

  final List<Map<String, String>> imagesData = [
    {
      'image': 'assets/img/copter1.jpg',
      'title': 'S200 Model Powered by NXP Flight Controller',
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 0.5,
    )..addListener(() {
        if (_pageController.page != null) {
          int newIndex = _pageController.page!.round() % imagesData.length;
          if (newIndex != _currentIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          }
        }
      });
    
    // Start the autoplay timer when the widget is first built
    _startAutoplay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stopAutoplay(); // Make sure to cancel the timer to prevent memory leaks
    super.dispose();
  }
  
  // --- NEW: Methods to control the autoplay timer ---
  void _startAutoplay() {
    // If a timer is already running, do nothing
    if (_autoplayTimer != null && _autoplayTimer!.isActive) return;
    _autoplayTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _nextImage();
    });
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
  }

  void _nextImage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _previousImage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 900;

    if (isSmallScreen) {
      return _buildMobileLayout();
    }
    
    return _buildDesktopLayout();
  }

  Widget _buildDesktopLayout() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SELECTED WORK',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          // Wrap the carousel in a MouseRegion to detect hover
          MouseRegion(
            onEnter: (_) => _stopAutoplay(), // Pause autoplay on hover
            onExit: (_) => _startAutoplay(),  // Resume autoplay when mouse leaves
            child: SizedBox(
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left_rounded, color: Colors.white, size: 60),
                    onPressed: _previousImage,
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = (_pageController.page! - index);
                              value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: Opacity(
                                opacity: pow(value, 2).toDouble(),
                                child: Transform.scale(
                                  scale: value,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                imagesData[index % imagesData.length]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right_rounded, color: Colors.white, size: 60),
                    onPressed: _nextImage,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              key: ValueKey<int>(_currentIndex),
              children: [
                Text(
                  imagesData[_currentIndex]['title']!,
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  imagesData[_currentIndex]['description']!,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'SELECTED WORK',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 20),
              itemCount: imagesData.length,
              separatorBuilder: (_, __) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[900],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        imagesData[index]['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              imagesData[index]['title']!,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              imagesData[index]['description']!,
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

