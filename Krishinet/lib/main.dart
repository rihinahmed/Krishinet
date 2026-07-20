import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'choose_path_screen.dart';

void main() {
  runApp(const KrishinetApp());
}

class KrishinetApp extends StatelessWidget {
  const KrishinetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishinet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF051424),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotateController;

  final Color primaryColor = const Color(0xFF54E167);
  final Color primaryContainer = const Color(0xFF2CC04B);
  final Color backgroundDeep = const Color(0xFF051424);

  @override
  void initState() {
    super.initState();

    // Pulse Animation for the center ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation Animation for the dashed ring
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Immersive Background Image
          Positioned.fill(
            child:
                (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
                    ? Container(color: const Color(0xFF051424))
                    : Image.asset('assets/images/bgimg.jpg', fit: BoxFit.cover),
          ),

          // 2. Gradient Overlay (Hero Gradient)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    backgroundDeep.withValues(alpha: 0.4),
                    backgroundDeep,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // 3. Main Content Canvas
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),

                  // 4. Centered Visual Focus (Expanding to fill available space)
                  Expanded(child: Center(child: _buildCenterVisual())),

                  // 5. Transactional Bottom Section
                  _buildBottomSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Krishinet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        _GlassContainer(
          width: 40,
          height: 40,
          borderRadius: 20,
          child: Icon(Icons.language, color: primaryColor, size: 20),
        ),
      ],
    );
  }

  Widget _buildCenterVisual() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing Outer Ring
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Rotating Dashed Ring (Simulated with CustomPaint or a simpler rotated container)
          RotationTransition(
            turns: _rotateController,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 1,
                  style:
                      BorderStyle
                          .none, // In a full app, use CustomPaint for true dashed lines
                ),
              ),
              // Simulating the dash array with a rotated gradient/pattern
              child: CustomPaint(
                painter: DashedCirclePainter(
                  color: primaryColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),

          // Center Icon
          Icon(Icons.eco, size: 64, color: primaryColor.withValues(alpha: 0.9)),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headlines
        Text(
          'Empowering\nEvery Acre',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFD4E4FA),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Harness precision satellite data and AI to optimize your cultivation journey.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: const Color(0xFFBCCBB7),
          ),
        ),
        const SizedBox(height: 24),

        // Bento Cards
        Row(
          children: [
            Expanded(
              child: _GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.insights,
                        color: primaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Yield AI',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFD4E4FA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.wb_sunny,
                        color: primaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Climate',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFD4E4FA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Primary Button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChoosePathScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryContainer,
            foregroundColor: const Color(0xFF00390E), // on-primary text
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: primaryContainer.withValues(alpha: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Footer Text
        Center(
          child: Text(
            'Join over 2.4M farmers worldwide',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFBCCBB7).withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper widget to create the Glassmorphism blur effect
class _GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const _GlassContainer({
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF122131).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Custom painter to draw the dashed circle from the SVG in the HTML
class DashedCirclePainter extends CustomPainter {
  final Color color;

  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw dashed circle logic
    const int dashCount = 40;
    const double dashAngle = 2 * 3.14159 / dashCount;

    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          i * dashAngle,
          dashAngle,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
