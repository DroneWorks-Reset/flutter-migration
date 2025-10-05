import 'package:droneworkz/dronebuilder.dart';
import 'package:droneworkz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the page files
import 'package:droneworkz/pages/home_page.dart';
import 'package:droneworkz/pages/works_page.dart';
import 'package:droneworkz/pages/about_page.dart';
import 'package:droneworkz/pages/contact_page.dart';
import 'package:droneworkz/pages/hire_us_page.dart';
import 'package:droneworkz/pages/career_page.dart';

// ADDED: Imports for web-specific functionality
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SideNav(),
        '/builder': (context) => Dronebuilder(),
        '/career': (context) => const CareerPage(),
      },
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
  late final PageController _pageController;
  final List<String> _pages = ['Home', 'Works', 'Drone Builder', 'About', 'Contact', 'Hire Us'];
  int? _hoveredIndex;
  bool _isBuilderButtonHovered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    int initialPage = 0;
    // On web, read the initial page from the URL hash
    if (kIsWeb) {
      final uri = Uri.tryParse(html.window.location.href);
      if (uri != null && uri.fragment.isNotEmpty) {
        final pageName = uri.fragment.replaceAll('/', '');
        final index = _pages.indexWhere((p) => p.toLowerCase().replaceAll(' ', '-') == pageName);
        if (index != -1) {
          initialPage = index;
        }
      }
    }
    
    _currentIndex = initialPage;
    _pageController = PageController(initialPage: _currentIndex);

    // Listen for browser back/forward button clicks
    if (kIsWeb) {
      html.window.onPopState.listen((_) {
        final hash = html.window.location.hash;
        final pageName = hash.isNotEmpty ? hash.substring(2) : 'home'; // Remove '#/'
        final index = _pages.indexWhere((p) => p.toLowerCase().replaceAll(' ', '-') == pageName);
        if (index != -1 && index != _currentIndex) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  // UPDATED: This function now updates the URL
  void _onNavItemTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
    _updateUrl(index);
  }

  // NEW: A function to update the browser's URL hash
  void _updateUrl(int index) {
    if (kIsWeb) {
      final pageName = _pages[index].toLowerCase().replaceAll(' ', '-');
      html.window.history.pushState(null, _pages[index], '/#/$pageName');
    }
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentIndex);
      }
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
                    onSelected: _onNavItemTapped,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: ListView.builder(
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
              onPageChanged: (index) {
                if (_currentIndex != index) {
                  setState(() => _currentIndex = index);
                  _updateUrl(index);
                }
              },
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
      onPageChanged: (index) {
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
          _updateUrl(index);
        }
      },
    );
  }
  
  Widget _buildPageContent(int index) {
    switch (_pages[index]) {
      case 'Home':
        return HomePage(
          pages: _pages,
          onHireUsPressed: () => _onNavItemTapped(_pages.indexOf('Hire Us')),
        );
      case 'Works':
        return WorksPage(); 
      case 'Drone Builder':
        return _buildDroneBuilderPage(context);
      case 'About':
        return AboutPage();
      case 'Contact':
        return ContactPage();
      case 'Hire Us':
        return HireUsPage(
          onGetInTouchPressed: () => _onNavItemTapped(_pages.indexOf('Contact')),
        );
      default:
        return const Center(
          child: Text("Page not found", style: TextStyle(color: Colors.white)),
        );
    }
  }

  Widget _buildDroneBuilderPage(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isBuilderButtonHovered = true),
        onExit: (_) => setState(() => _isBuilderButtonHovered = false),
        child: GestureDetector(
          onTap: () {
            if (kIsWeb) {
              html.window.open('/#/builder', '_blank');
            } else {
              Navigator.pushNamed(context, '/builder');
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: _isBuilderButtonHovered
                ? (Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-0.05))
                : Matrix4.identity(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isBuilderButtonHovered
                    ? [Colors.blueAccent.shade400, Colors.cyanAccent.shade400]
                    : [Colors.blue.shade900.withOpacity(0.8), Colors.grey.shade800.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isBuilderButtonHovered
                  ? [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Go to Drone Builder',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = _currentIndex == index;
    final bool isHovered = _hoveredIndex == index;
    final String navText = isSelected ? '0${index + 1} ${_pages[index]}' : _pages[index];

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => _onNavItemTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 24,
                width: 4,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                navText,
                style: TextStyle(
                  color: isSelected || isHovered ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

