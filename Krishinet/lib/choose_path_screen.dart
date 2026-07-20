import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'farmer_login_screen.dart';
import 'farmer_signup_screen.dart';
import 'expert_login_screen.dart';
import 'expert_signup_screen.dart';
import 'buyer_login_screen.dart';
import 'buyer_signup_screen.dart';
import 'ngo_login_screen.dart';
import 'ngo_signup_screen.dart';
import 'admin_login_screen.dart';

class ChoosePathScreen extends StatefulWidget {
  const ChoosePathScreen({super.key});

  @override
  State<ChoosePathScreen> createState() => _ChoosePathScreenState();
}

class _ChoosePathScreenState extends State<ChoosePathScreen>
    with SingleTickerProviderStateMixin {
  // Theme Colors from Tailwind config
  final Color backgroundDeep = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color errorColor = const Color(0xFFFFB4AB);
  final Color onErrorColor = const Color(0xFF690005);
  final Color cardGlass = const Color(0xFF1F2222).withValues(alpha: 0.6);
  final Color cardActive = const Color(0xFF122131);

  int _selectedIndex = 0; // Default to Farmer (0)

  // Particle Animation System
  late AnimationController _particleController;
  late List<Particle> _particles;
  final Random _random = Random();

  final List<Map<String, dynamic>> _roles = [
    {'title': 'Farmer', 'icon': Icons.agriculture},
    {'title': 'Agri-Expert', 'icon': Icons.psychology},
    {'title': 'Buyer', 'icon': Icons.shopping_cart},
    {'title': 'Government Officials', 'icon': Icons.favorite},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize Particles
    _particles = List.generate(30, (index) => _generateParticle());
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      _updateParticles();
    });
    _particleController.repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  Particle _generateParticle() {
    return Particle(
      x: _random.nextDouble() * 400, // Screen width approx
      y: _random.nextDouble() * 900, // Screen height approx
      speed: _random.nextDouble() * 0.5 + 0.2,
      radius: _random.nextDouble() * 2 + 1,
      angle: _random.nextDouble() * 2 * pi,
      alpha: _random.nextDouble() * 0.5 + 0.1,
    );
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.y -= particle.speed;
      particle.x += sin(particle.angle) * 0.5;
      particle.angle += 0.02;

      // Wrap around screen
      if (particle.y < -10) {
        particle.y = 900;
        particle.x = _random.nextDouble() * 400;
      }
    }
    setState(() {}); // Trigger rebuild for CustomPainter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDeep,
      body: Stack(
        children: [
          // 1. Animated Particle Background
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                color: primaryColor,
              ),
            ),
          ),

          // 2. Main UI Content
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(),
                        const SizedBox(height: 32),
                        _buildRoleGrid(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // 3. Pinned Bottom Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button & Logo
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF273647), // surface-container-highest
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: primaryColor, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Krishinet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          // Profile Avatar with Notification Badge & Secure Admin Gateway
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminLoginScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF273647), // surface-container-highest
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.security, color: primaryColor, size: 20),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(
                          0xFF73FE80,
                        ).withValues(alpha: 0.2), // primary-fixed
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/200', // Placeholder image
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '8',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: onErrorColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Path',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your role to continue your journey into the future of precision agriculture.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _roles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final role = _roles[index];
        final isActive = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: isActive ? cardActive : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isActive
                        ? primaryColor
                        : Colors.white.withValues(alpha: 0.05),
                width: isActive ? 2 : 1,
              ),
              boxShadow:
                  isActive
                      ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.15),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ]
                      : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: isActive ? 0 : 20,
                  sigmaY: isActive ? 0 : 20,
                ),
                child: Container(
                  color: isActive ? Colors.transparent : cardGlass,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Active Glow Background effect
                      if (isActive)
                        Positioned(
                          top: -30,
                          right: -30,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withValues(alpha: 0.1),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Card Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? primaryColor.withValues(alpha: 0.2)
                                      : onSurfaceVariant.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              role['icon'] as IconData,
                              color: isActive ? primaryColor : onSurfaceVariant,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isActive ? primaryColor : onSurface,
                            ),
                            child: Text(role['title'] as String),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: backgroundDeep.withValues(alpha: 0.7),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Log In Button (Secondary Action)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (_selectedIndex == 0) {
                      // Redirect to Farmer Login
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, anim, secAnim) =>
                                  const FarmerLoginScreen(),
                          transitionsBuilder:
                              (context, anim, secAnim, child) =>
                                  FadeTransition(opacity: anim, child: child),
                        ),
                      );
                    } else if (_selectedIndex == 1) {
                      // Redirect to Agri-Expert Login
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, anim, secAnim) =>
                                  const ExpertLoginScreen(),
                          transitionsBuilder:
                              (context, anim, secAnim, child) =>
                                  FadeTransition(opacity: anim, child: child),
                        ),
                      );
                    } else if (_selectedIndex == 2) {
                      // Redirect to Buyer Login
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, anim, secAnim) =>
                                  const BuyerLoginScreen(),
                          transitionsBuilder:
                              (context, anim, secAnim, child) =>
                                  FadeTransition(opacity: anim, child: child),
                        ),
                      );
                    } else if (_selectedIndex == 3) {
                      // Redirect to NGO Login
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, anim, secAnim) =>
                                  const NgoLoginScreen(),
                          transitionsBuilder:
                              (context, anim, secAnim, child) =>
                                  FadeTransition(opacity: anim, child: child),
                        ),
                      );
                    } else {
                      // Fallback for Buyer/NGO
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Login for ${_roles[_selectedIndex]['title']} coming soon.',
                          ),
                          backgroundColor: const Color(
                            0xFF1F2222,
                          ).withValues(alpha: 0.7),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Sign Up Button (Primary Action)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Check if Farmer (index 0) is selected
                    if (_selectedIndex == 0) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const FarmerSignupScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                    // Add this block to route to the Agri-Expert Signup (index 1)
                    else if (_selectedIndex == 1) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ExpertSignupScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    } else if (_selectedIndex == 2) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const BuyerSignupScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    } else if (_selectedIndex == 3) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const NgoSignupScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Registration for ${_roles[_selectedIndex]['title']} coming soon.',
                          ),
                          backgroundColor:
                              cardGlass, // Ensure cardGlass is defined in your state
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: const Color(
                      0xFF00390E,
                    ), // High contrast text on primary
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withValues(alpha: 0.4),
                  ),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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

// --- Particle System Classes ---

class Particle {
  double x;
  double y;
  double speed;
  double radius;
  double angle;
  double alpha;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.angle,
    required this.alpha,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = color.withValues(alpha: particle.alpha)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(particle.x, particle.y), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
