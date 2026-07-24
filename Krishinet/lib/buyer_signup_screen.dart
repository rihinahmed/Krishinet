import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'buyer_login_screen.dart';

class BuyerSignupScreen extends StatefulWidget {
  const BuyerSignupScreen({super.key});

  @override
  State<BuyerSignupScreen> createState() => _BuyerSignupScreenState();
}

class _BuyerSignupScreenState extends State<BuyerSignupScreen> {
  // Theme Colors
  final Color background = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color surfaceContainerLow = const Color(0xFF0D1C2D);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);

  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all details')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final email = "${phone.replaceAll('+', '')}@krishinet.com";
      await AuthService.register(
        name: name,
        email: email,
        password: password,
        role: 'buyer',
        phone: phone,
      );
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Color(0xFF54E167),
          behavior: SnackBarBehavior.floating,
        ),
      );
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const BuyerLoginScreen()),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red[800]),
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
  }

  void _handleGoogleSignup() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await AuthService.register(
        name: "Google Buyer",
        email: "googlebuyer@krishinet.com",
        password: "googlepassword123",
        role: 'buyer',
        phone: "+8801787654321",
      );
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Registration successful via Google!'),
          backgroundColor: Color(0xFF54E167),
          behavior: SnackBarBehavior.floating,
        ),
      );
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const BuyerLoginScreen()),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red[800]),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar:
          true, // Allows background to flow under the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. Ambient Background Glows
          Positioned(
            top: -100,
            left: -50,
            child: _buildBlurOrb(size: 350, opacity: 0.1),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: _buildBlurOrb(size: 250, opacity: 0.05),
          ),

          // 2. Animated Particle System
          const Positioned.fill(child: _ParticleBackground()),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header / Titles
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join the Network',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access the freshest harvests directly from the source with Verdant Precision.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // Glassmorphic Form Card
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF1F2222,
                              ).withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(
                                  0xFF879583,
                                ).withValues(alpha: 0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.05),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildInputField(
                                  label: 'Full Name',
                                  hint: 'John Doe',
                                  icon: Icons.person_outline,
                                  controller: _nameController,
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  label: 'Business/Company Name (optional)',
                                  hint: 'Acme Organics',
                                  icon: Icons.corporate_fare,
                                  controller: _businessController,
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  label: 'Mobile Number',
                                  hint: '+1 (555) 000-0000',
                                  icon: Icons.smartphone,
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneController,
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
                                          () =>
                                              _obscurePassword =
                                                  !_obscurePassword,
                                        ),
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: outlineVariant,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Terms and Conditions Checkbox
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: _agreedToTerms,
                                        onChanged:
                                            (val) => setState(
                                              () =>
                                                  _agreedToTerms = val ?? false,
                                            ),
                                        activeColor: primaryColor,
                                        checkColor: const Color(0xFF00390E),
                                        side: BorderSide(color: outlineVariant),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.plusJakartaSans(
                                            color: onSurfaceVariant,
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'I agree to the ',
                                            ),
                                            TextSpan(
                                              text: 'Terms of Service',
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const TextSpan(text: ' and '),
                                            TextSpan(
                                              text: 'Privacy Policy',
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const TextSpan(text: '.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),

                                // Submit Button
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSignup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: const Color(0xFF00390E),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 8,
                                    shadowColor: primaryColor.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  child:
                                      _isLoading
                                          ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF00390E),
                                                  ),
                                            ),
                                          )
                                          : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Start Buying',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.trending_flat,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                ),

                                // Divider
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(color: outlineVariant),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'OR CONTINUE WITH',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: outlineVariant,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(color: outlineVariant),
                                      ),
                                    ],
                                  ),
                                ),

                                // Social Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialButton(
                                        icon: Icons.g_mobiledata,
                                        label: 'Google',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialButton(
                                        icon: Icons.facebook,
                                        label: 'Facebook',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Footer Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Are you a producer? ",
                          style: GoogleFonts.plusJakartaSans(
                            color: onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Seller Signup
                          },
                          child: Text(
                            'Sign up as a Seller',
                            style: GoogleFonts.plusJakartaSans(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurOrb({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: opacity),
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
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
          style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: outlineVariant.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(icon, color: outlineVariant, size: 20),
            suffixIcon: trailing,
            filled: true,
            fillColor: surfaceContainerLow,
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

  Widget _buildSocialButton({required IconData icon, required String label}) {
    return OutlinedButton.icon(
      onPressed: () {
        if (label == 'Google') {
          _handleGoogleSignup();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label signup is not configured.')),
          );
        }
      },
      icon: Icon(icon, color: onSurface, size: 24),
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ==========================================
// BACKGROUND PARTICLE ANIMATION SYSTEM
// ==========================================

class _ParticleBackground extends StatefulWidget {
  const _ParticleBackground();

  @override
  State<_ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<_ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    // Initialize particles
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle(random));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      for (var particle in _particles) {
        particle.update();
      }
      setState(() {}); // Trigger repaint
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
      painter: ParticlePainter(_particles),
      size: Size.infinite,
    );
  }
}

class Particle {
  double x, y;
  double speed;
  double radius;
  double alpha;
  math.Random random;

  Particle(this.random)
    : x = random.nextDouble(),
      y = random.nextDouble(),
      speed = 0.0005 + random.nextDouble() * 0.001,
      radius = 1.0 + random.nextDouble() * 2.5,
      alpha = random.nextDouble();

  void update() {
    // Float upwards slowly
    y -= speed;
    // Slight horizontal drift
    x += (random.nextDouble() - 0.5) * 0.001;

    // Reset when off screen
    if (y < 0) {
      y = 1.0;
      x = random.nextDouble();
    }

    // Pulsing alpha effect
    alpha += (random.nextDouble() - 0.5) * 0.02;
    alpha = alpha.clamp(0.1, 0.6);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF54E167) // Verdant Green
          ..style = PaintingStyle.fill;

    for (var particle in particles) {
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
