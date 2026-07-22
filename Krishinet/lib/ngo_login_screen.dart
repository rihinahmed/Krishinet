import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ngo_signup_screen.dart';
import 'govt_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class NgoLoginScreen extends StatefulWidget {
  const NgoLoginScreen({super.key});

  @override
  State<NgoLoginScreen> createState() => _NgoLoginScreenState();
}

class _NgoLoginScreenState extends State<NgoLoginScreen>
    with TickerProviderStateMixin {
  // Theme Colors
  final Color background = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color surfaceContainerHighest = const Color(0xFF1C2B3C);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Entry Animation Controller
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Setup Entry Animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // 1. Background Gradient & Image substitute
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [background.withValues(alpha: 0.5), background],
                ),
              ),
            ),
          ),

          // 2. Continuous Particle Animation
          const Positioned.fill(child: _NgoParticleBackground()),

          // 3. Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildGlassLoginCard(),
                              const SizedBox(height: 32),
                              _buildFooterDecoration(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16, // Respects safe area
            left: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: background.withValues(
                      alpha: 0.5,
                    ), // Matches your glass panel theme
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      ); // Navigate back to the previous screen
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: background.withValues(alpha: 0.8)),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Krishinet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.notifications_none, color: primaryColor),
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      color: surfaceContainerHighest,
                    ),
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassLoginCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF122131).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF3D4A3B).withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Branding/Identity
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(Icons.favorite, color: primaryColor, size: 32),
                  ),
                ),
                Text(
                  'Government Officials Portal',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Empowering communities through agricultural precision and collective heart.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                _buildInputField(
                  label: 'Organization Email',
                  hint: 'partner@org.krishinet.org',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                  trailing: GestureDetector(
                    onTap:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Remember Me & Forgot Password
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged:
                                (val) =>
                                    setState(() => _rememberMe = val ?? false),
                            activeColor: primaryColor.withValues(alpha: 0.8),
                            checkColor: const Color(0xFF00390E),
                            side: BorderSide(color: outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remember Me',
                          style: GoogleFonts.plusJakartaSans(
                            color: onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Forgot Password?',
                      style: GoogleFonts.plusJakartaSans(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

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
                                      (context) => const GovtDashboardScreen(),
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
                    foregroundColor: const Color(0xFF00390E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withValues(alpha: 0.4),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Collaborating With Section
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF122131),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'COLLABORATING WITH',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.diversity_1,
                      color: onSurfaceVariant.withValues(alpha: 0.6),
                      size: 32,
                    ),
                    const SizedBox(width: 24),
                    Icon(
                      Icons.groups,
                      color: onSurfaceVariant.withValues(alpha: 0.6),
                      size: 32,
                    ),
                    const SizedBox(width: 24),
                    Icon(
                      Icons.volunteer_activism,
                      color: onSurfaceVariant.withValues(alpha: 0.6),
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Text(
                      "New partner? ",
                      style: GoogleFonts.plusJakartaSans(
                        color: onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NgoSignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Apply for Access',
                        style: GoogleFonts.plusJakartaSans(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? trailing,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: onSurfaceVariant,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword && _obscurePassword,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariant.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(icon, color: onSurfaceVariant),
            suffixIcon: trailing,
            filled: true,
            fillColor: surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterDecoration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user,
          color: onSurfaceVariant.withValues(alpha: 0.4),
          size: 14,
        ),
        const SizedBox(width: 8),
        Text(
          'Secure encrypted access for Government Officials partners',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// BACKGROUND PARTICLE ANIMATION SYSTEM
// ==========================================

class _NgoParticleBackground extends StatefulWidget {
  const _NgoParticleBackground();

  @override
  State<_NgoParticleBackground> createState() => _NgoParticleBackgroundState();
}

class _NgoParticleBackgroundState extends State<_NgoParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_NgoParticle> _particles = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 25; i++) {
      _particles.add(_NgoParticle(random));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      for (var particle in _particles) {
        particle.update();
      }
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NgoParticlePainter(_particles),
      size: Size.infinite,
    );
  }
}

class _NgoParticle {
  double x, y;
  double speed;
  double radius;
  double alpha;
  math.Random random;

  _NgoParticle(this.random)
    : x = random.nextDouble(),
      y = random.nextDouble(),
      speed =
          0.0005 +
          random.nextDouble() * 0.0015, // Slightly faster upward movement
      radius = 1.0 + random.nextDouble() * 2.0,
      alpha = random.nextDouble() * 0.3; // Lower opacity for subtlety

  void update() {
    y -= speed; // Move up

    // Reset when off screen (top)
    if (y < 0) {
      y = 1.1; // Start slightly below the screen
      x = random.nextDouble();
    }

    // Pulsing alpha
    alpha += (random.nextDouble() - 0.5) * 0.01;
    alpha = alpha.clamp(0.05, 0.4);
  }
}

class _NgoParticlePainter extends CustomPainter {
  final List<_NgoParticle> particles;

  _NgoParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // NGO specific verdant green color for particles
      paint.color = const Color(0xFF54E167).withValues(alpha: particle.alpha);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
