import 'package:flutter/material.dart';
import 'dart:math';

class HireUsPage extends StatefulWidget {
  // This page now requires a function to be passed to it for navigation.
  final VoidCallback onGetInTouchPressed;
  
  const HireUsPage({super.key, required this.onGetInTouchPressed});

  @override
  State<HireUsPage> createState() => _HireUsPageState();
}

class _HireUsPageState extends State<HireUsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Layer 1: Animated Grid Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: GridPainter(animationValue: _controller.value),
                );
              },
            ),
          ),

          // Layer 2: Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "LET'S BUILD TOGETHER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "From initial concepts to full-scale production, we offer services to bring your vision to life.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueAccent.shade100, fontSize: 18),
                  ),
                  const SizedBox(height: 60),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 30,
                    runSpacing: 30,
                    children: [
                      _ServiceCard(
                        icon: Icons.lightbulb_outline,
                        title: 'Consultation',
                        description: 'Expert advice to kickstart your project and navigate technical challenges.',
                      ),
                      _ServiceCard(
                        icon: Icons.design_services_outlined,
                        title: 'Design Guidance',
                        description: 'Collaborate with our engineers to refine your schematics and 3D models.',
                      ),
                      _ServiceCard(
                        icon: Icons.rocket_launch_outlined,
                        title: 'Full Package Drone Design',
                        description: 'A complete, end-to-end solution from concept to a fully functional prototype.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  _StyledButton(
                    onPressed: widget.onGetInTouchPressed, // Uses the function passed from main.dart
                    text: 'Get in Touch',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Reusable Animated Widgets ---

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 280,
        height: 320,
        padding: const EdgeInsets.all(24),
        transform: _isHovered
            ? (Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(-0.02)..rotateX(0.02)..scale(1.05))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _isHovered ? Colors.blueAccent.withOpacity(0.5) : Colors.white.withOpacity(0.1)),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: Colors.blueAccent, size: 40),
            const SizedBox(height: 20),
            Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(widget.description, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _StyledButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const _StyledButton({required this.onPressed, required this.text});

  @override
  _StyledButtonState createState() => _StyledButtonState();
}

class _StyledButtonState extends State<_StyledButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isHovered ? Colors.blueAccent.shade700 : Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          shadowColor: Colors.blueAccent.withOpacity(0.5),
          elevation: _isHovered ? 15 : 8,
          animationDuration: const Duration(milliseconds: 200),
        ),
        child: Text(widget.text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double animationValue;
  GridPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..strokeWidth = 1.0;

    const double gridSize = 50.0;
    final double yOffset = (animationValue * gridSize) % gridSize;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = -gridSize + yOffset; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

