import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/utils/constants.dart';
import 'farmer_signup_screen.dart';
import 'farmer_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class FarmerLoginScreen extends StatefulWidget {
  const FarmerLoginScreen({super.key});

  @override
  State<FarmerLoginScreen> createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen>
    with TickerProviderStateMixin {
  // Theme Colors
  final Color backgroundDeep = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color inputBg = const Color(0xFF2A2D2D);
  final Color cardGlass = const Color(0xFF1F2222).withValues(alpha: 0.7);

  // State
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Animation Controllers
  late AnimationController _particleController;
  late List<Particle> _particles;
  final Random _random = Random();

  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Setup Particles
    _particles = List.generate(40, (index) => _generateParticle());
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      _updateParticles();
    });
    _particleController.repeat();

    // Setup Entrance Animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _entranceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Particle _generateParticle() {
    return Particle(
      x: _random.nextDouble() * 800,
      y: _random.nextDouble() * 1000,
      speed: _random.nextDouble() * 0.4 + 0.1,
      radius: _random.nextDouble() * 2 + 1,
      angle: _random.nextDouble() * 2 * pi,
      alpha: _random.nextDouble() * 0.4 + 0.1,
    );
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.y -= particle.speed;
      particle.x += sin(particle.angle) * 0.3;
      particle.angle += 0.015;

      if (particle.y < -10) {
        particle.y = 1000;
        particle.x = _random.nextDouble() * 800;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDeep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive check for tablet/desktop side panel
          final bool isWideScreen = constraints.maxWidth > 900;

          return Stack(
            children: [
              // Particles Background
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    color: primaryColor,
                  ),
                ),
              ),

              // Main Content
              Row(
                children: [
                  // Form Area (Full width on mobile, 2/3 on desktop)
                  Expanded(
                    flex: 2,
                    child: SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildHeader(),
                                    const SizedBox(height: 24),
                                    _buildLoginCard(),
                                    const SizedBox(height: 16),
                                    _buildFooter(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Side Decoration Image (Only visible on wide screens > 900px)
                  if (isWideScreen)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppConstants.buildNetworkImage(
                                context: context,
                                url:
                                    'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=1000&auto=format&fit=crop',
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: backgroundDeep,
                                      child: Icon(
                                        Icons.park,
                                        color: primaryColor,
                                        size: 48,
                                      ),
                                    ),
                              ),
                              // Gradient Overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      backgroundDeep.withValues(alpha: 0.9),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Image Text
                              Positioned(
                                bottom: 40,
                                left: 40,
                                right: 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sustainable\nProsperity.',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Empowering the world's growers with real-time analytics and autonomous insights.",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Back Button Overlay
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF273647),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(
              0xFF004713,
            ).withValues(alpha: 0.2), // primary-container
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          ),
          child: Icon(Icons.agriculture, color: primaryColor, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          'Krishinet',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Secure precision farming dashboard for the modern agriculturalist.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardGlass,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Farmer ID Input
              Text(
                'Farmer Mobile / ID',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onSurfaceVariant,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.plusJakartaSans(
                  color: onSurface,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your ID or Number',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  prefixIcon: Icon(
                    Icons.badge,
                    color: onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Input
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    'Security Key',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {}, // Forgot password action
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: GoogleFonts.plusJakartaSans(
                  color: onSurface,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Sign In Button
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter email and password',
                                ),
                              ),
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          try {
                            await AuthService.login(
                              email: email,
                              password: password,
                            );
                            navigator.pushReplacement(
                              MaterialPageRoute(
                                builder:
                                    (context) => const FarmerDashboardScreen(),
                              ),
                            );
                          } on ApiException catch (e) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(e.message),
                                backgroundColor: Colors.red[800],
                              ),
                            );
                          } catch (e) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Connection error: $e'),
                                backgroundColor: Colors.red[800],
                              ),
                            );
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: const Color(0xFF00390E), // on-primary
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: primaryColor.withValues(alpha: 0.3),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Sign In',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: outlineVariant.withValues(alpha: 0.4)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(
              child: Divider(color: outlineVariant.withValues(alpha: 0.4)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'New to the precision network?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
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
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }, // Navigate to sign up
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              Text(
                'Join Krishinet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              Icon(Icons.energy_savings_leaf, color: primaryColor, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

// Particle Engine Classes
class Particle {
  double x, y, speed, radius, angle, alpha;
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
