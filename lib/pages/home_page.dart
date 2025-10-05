import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

// Enum to manage the different stages of the drone's animation sequence.
enum DroneState { landed, spinningUp, takingOff, hovering }

// A simple class to hold the 3D position and color of a star for the background.
class Star {
  double x, y, z;
  Color color;
  Star(this.x, this.y, this.z, this.color);
}

class HomePage extends StatefulWidget {
  final VoidCallback onHireUsPressed;
  final List<String> pages;

  const HomePage({
    super.key,
    required this.onHireUsPressed,
    required this.pages,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Animation state and controllers
  DroneState _droneState = DroneState.landed;
  late AnimationController _takeoffController;
  late Animation<Alignment> _takeoffAlignmentAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _hoverController;
  late Animation<Offset> _hoverAnimation;
  late AnimationController _starfieldController;
  late List<Star> _stars;
  final int _starCount = 700; // Increased star count for a denser field
  final double _speed = 2.5;   // Slightly increased speed

  // State for mobile drag interaction
  bool _isDragging = false;
  Offset _dronePosition = Offset.zero;
  bool _mobileTakeoffTriggered = false;
  bool _takeoffSequenceStarted = false;


  final List<Color> _starColors = [
    Colors.cyanAccent,
    Colors.pinkAccent,
    Colors.purpleAccent.shade100,
    Colors.lightBlueAccent,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();

    _starfieldController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _stars = List.generate(_starCount, (index) => _getRandomStar(isInitial: true));

    _takeoffController = AnimationController(vsync: this, duration: const Duration(seconds: 3)); // Slower, more dramatic takeoff
    
    final CurvedAnimation takeoffCurve = CurvedAnimation(parent: _takeoffController, curve: Curves.easeInOutCubic);
    
    // UPDATED: Drone now moves further up and shrinks more
    _takeoffAlignmentAnimation = AlignmentTween(
      begin: Alignment.bottomRight,
      end: Alignment(0.7, -0.5), // Moves higher on the screen
    ).animate(takeoffCurve);

    _scaleAnimation = Tween<double>(begin: 1.5, end: 0.7).animate(takeoffCurve); // Shrinks more

    _hoverController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _hoverAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.05))
      .animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut));

    _takeoffController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _droneState = DroneState.hovering);
        if (!_isDragging) {
          _hoverController.repeat(reverse: true);
        }
      }
    });

    _startTakeoffSequence();
  }
  
  @override
 void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_takeoffSequenceStarted) {
      _takeoffSequenceStarted = true;
      final size = MediaQuery.of(context).size;
      // Set initial position for mobile drone to the bottom right
      _dronePosition = Offset(size.width - 150, size.height - 200);

      // Only start the automatic takeoff sequence on wide screens
      if (size.width >= 900) {
        _startDesktopTakeoffSequence();
      }
    }
  }
  void _startDesktopTakeoffSequence() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _droneState = DroneState.spinningUp);
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _droneState = DroneState.takingOff);
    _takeoffController.forward();
  }
  
  void _startTakeoffSequence() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _droneState = DroneState.spinningUp);
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _droneState = DroneState.takingOff);
    _takeoffController.forward();
  }

  Star _getRandomStar({bool isInitial = false}) {
    final Random random = Random();
    return Star(
      (random.nextDouble() - 0.5) * 2000,
      (random.nextDouble() - 0.5) * 2000,
      isInitial ? random.nextDouble() * 2000 : 2000,
      _starColors[random.nextInt(_starColors.length)],
    );
  }
  // A separate sequence for mobile that is triggered by user interaction
  void _triggerMobileTakeoff() async {
    if (_mobileTakeoffTriggered) return;
    _mobileTakeoffTriggered = true;

    setState(() => _droneState = DroneState.spinningUp);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _droneState = DroneState.hovering);
    _hoverController.repeat(reverse: true);
  }


  @override
  void dispose() {
    _starfieldController.dispose();
    _takeoffController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Stack(
            children: [
              // Layer 1: The Animated Hyperspeed Background
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _starfieldController,
                  builder: (context, child) {
                    for (var star in _stars) {
                      star.z -= _speed;
                      if (star.z <= 0) {
                        var newStar = _getRandomStar();
                        star.x = newStar.x;
                        star.y = newStar.y;
                        star.z = newStar.z;
                        star.color = newStar.color;
                      }
                    }
                    return CustomPaint(
                      painter: StarfieldPainter(stars: _stars),
                    );
                  },
                ),
              ),

              // Layer 2: Platform-specific layout for Drone and Text
              if (isWide)
                _buildDesktopLayout(context)
              else
                _buildMobileLayout(context),
            ],
          );
        },
      ),
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Drone animation is aligned to the side
        AnimatedBuilder(
          animation: _takeoffController,
          builder: (context, child) {
            return Align(
              alignment: _takeoffAlignmentAnimation.value,
              child: child,
            );
          },
          child: _buildAnimatedDrone(screenWidth * 0.4, isWide: true),
        ),
        // Banner text is aligned to the left
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: _buildBannerText(screenWidth, widget.onHireUsPressed),
          ),
        ),
      ],
    );
  }
  
  // --- MOBILE LAYOUT (CREATIVE & INTERACTIVE) ---
  Widget _buildMobileLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Align(
          alignment: Alignment(0.0, -0.6),
          child: _buildBannerText(screenWidth, widget.onHireUsPressed),
        ),
        Positioned(
          left: _dronePosition.dx - (screenWidth * 0.25), // Center the drone
          top: _dronePosition.dy - (screenWidth * 0.25),
          child: GestureDetector(
            onTap: _triggerMobileTakeoff, // Trigger takeoff on first tap
            onPanStart: (details) {
              _triggerMobileTakeoff(); // Also trigger on first drag
              setState(() => _isDragging = true);
              _hoverController.stop();
            },
            onPanUpdate: (details) => setState(() => _dronePosition += details.delta),
            onPanEnd: (details) {
              setState(() => _isDragging = false);
              if (_droneState == DroneState.hovering) _hoverController.repeat(reverse: true);
            },
            child: _buildAnimatedDrone(screenWidth * 0.5, isWide: false),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedDrone(double width, {required bool isWide}) {
    Widget drone;
    // On mobile, we skip the landed state for a faster, interactive start.
    if (_droneState == DroneState.landed) {
      drone = SvgPicture.asset('img/drone_landed.svg');
    } else {
      drone = SvgPicture.asset('img/drone_spinning.svg');
    }
    
    Widget sizedDrone = SizedBox(width: width, height: width, child: drone);

    // Apply hover animation only when the state is hovering and not being dragged
    if (_droneState == DroneState.hovering && !_isDragging) {
      sizedDrone = SlideTransition(position: _hoverAnimation, child: sizedDrone);
    }
    
    // Only apply the dramatic scale animation on the desktop version
    if (isWide) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: sizedDrone,
      );
    }
    
    // Mobile version doesn't get the scale effect to feel more direct
    return sizedDrone;
  }
}

// --- Helper widgets and CustomPainter remain the same ---
class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  StarfieldPainter({required this.stars});
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final paint = Paint();
    for (var star in stars) {
      if (star.z > 0) {
        final double sx = (star.x / (star.z * 0.5)) * centerX + centerX;
        final double sy = (star.y / (star.z * 0.5)) * centerY + centerY;
        final double radius = (1.0 - star.z / 2000).clamp(0.1, 2.5);
        if (sx > 0 && sx < size.width && sy > 0 && sy < size.height) {
          paint.color = star.color;
          canvas.drawCircle(Offset(sx, sy), radius, paint);
        }
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget _buildBannerText(double screenWidth, VoidCallback onHireUsPressed) {
  final fontSize = screenWidth < 600 ? 32.0 : 68.0;
  return Column(
    mainAxisSize: MainAxisSize.min, // Make column only as tall as its children
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
        onPressed: onHireUsPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (states) => states.contains(MaterialState.hovered)
                ? const Color.fromARGB(255, 0, 0, 255)
                : const Color.fromARGB(170, 0, 0, 255),
          ),
          padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
            (states) => states.contains(MaterialState.hovered)
                ? const EdgeInsets.all(30)
                : const EdgeInsets.all(20),
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
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    ],
  );
}

