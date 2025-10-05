import 'package:flutter/material.dart';
import 'dart:ui';

class CareerPage extends StatefulWidget {
  const CareerPage({super.key});

  @override
  State<CareerPage> createState() => _CareerPageState();
}

class _CareerPageState extends State<CareerPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
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
      appBar: AppBar(
        title: Text("Careers", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // This is a simple way to close the tab; a more robust solution
            // would involve JS interop, but this works for most modern browsers.
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      Colors.blueAccent.withOpacity(0.15),
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
              child: Column(
                children: [
                  const Text(
                    "JOIN OUR TEAM",
                    style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We are always looking for passionate individuals to join our mission.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueAccent.shade200, fontSize: 18),
                  ),
                  const SizedBox(height: 60),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 30,
                    runSpacing: 30,
                    children: [
                      _HoverTiltCard(child: _buildRoleSection(role: '3D MODEL DESIGNER', imagePath: 'assets/img/about-winners.jpg')),
                      _HoverTiltCard(child: _buildRoleSection(role: 'EMBEDDED ENGINEERS', imagePath: 'assets/img/about-history.jpg')),
                      _HoverTiltCard(child: _buildRoleSection(role: 'MARKETING', imagePath: 'assets/img/about-philosophy.jpg')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSection({required String role, required String imagePath}) {
    return SizedBox(
      width: 250,
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 15),
          Text(role, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        ],
      ),
    );
  }
}

class _HoverTiltCard extends StatefulWidget {
  final Widget child;
  const _HoverTiltCard({required this.child});

  @override
  _HoverTiltCardState createState() => _HoverTiltCardState();
}

class _HoverTiltCardState extends State<_HoverTiltCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: _isHovered ? (Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(-0.02)..rotateX(0.02)) : Matrix4.identity(),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          boxShadow: _isHovered ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)] : [],
        ),
        child: widget.child,
      ),
    );
  }
}

