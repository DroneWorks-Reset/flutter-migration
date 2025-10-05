import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart'; // ADDED: For opening URLs

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin {
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

  // --- ADDED: Helper function to launch URLs ---
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
      print('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          _buildScrollableContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
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
                    Colors.blue.withOpacity(0.15),
                    Colors.black,
                  ],
                ),
              ),
            );
          },
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/img/about-visual.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeadline(),
                const SizedBox(height: 30),
                _StyledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/career');
                  },
                  text: 'Explore Careers',
                ),
                const SizedBox(height: 60),
                Text(
                  "Our Founders", // UPDATED: Title changed
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    // UPDATED: Now passing the LinkedIn URL to each founder card
                    _HoverTiltCard(
                      onTap: () => _launchURL('https://www.linkedin.com/in/ajaya-dahal-137b94108/'),
                      child: _buildFounderSection(name: 'Ajaya Dahal', title: 'Founder & System Software', imagePath: 'img/Ajaya_headshot.png'),
                    ),
                    _HoverTiltCard(
                      onTap: () => _launchURL('https://www.linkedin.com/in/aaron-uram-59ab5242/'),
                      child: _buildFounderSection(name: 'Aaron Uram', title: 'Founder & Frame Designer', imagePath: 'img/Profile_Shot_Aaron.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Text(
                    'DroneWorkz.AI is a team of dedicated professionals focused on creating innovative solutions using cutting-edge drone technology. Our team is built on passion and creativity to bring you the future of 3D modeling, embedded engineering, and marketing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18, height: 1.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadline() {
    return Column(
      children: [
        const Text(
          "WE BELIEVE IN PASSIONATE PEOPLE",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 52,
            fontWeight: FontWeight.w900,
            fontFamily: "Montserrat",
            height: 1.2,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Text(
            "DroneWorkz.AI is not just a company; it's a collective of dreamers, builders, and innovators.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueAccent.shade100,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  // UPDATED: This widget now builds the founder cards with their actual images.
  Widget _buildFounderSection({required String name, required String title, required String imagePath}) {
    return SizedBox(
      width: 280,
      height: 320,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
                // Fallback in case the image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Icon(Icons.person_outline, color: Colors.blueAccent, size: 80),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.1)),
        ],
      ),
    );
  }
}

// --- Reusable Animated Widgets ---
class _HoverTiltCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap; // ADDED: Callback for tapping
  const _HoverTiltCard({required this.child, required this.onTap});

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
      cursor: SystemMouseCursors.click, // Show a click cursor on hover
      child: GestureDetector(
        onTap: widget.onTap, // Use the passed-in onTap function
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

