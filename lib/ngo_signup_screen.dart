import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'ngo_login_screen.dart';

class NgoSignupScreen extends StatefulWidget {
  const NgoSignupScreen({super.key});

  @override
  State<NgoSignupScreen> createState() => _NgoSignupScreenState();
}

class _NgoSignupScreenState extends State<NgoSignupScreen>
    with TickerProviderStateMixin {
  // Theme Colors
  final Color background = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color cardBg = const Color(0xFF1F2222);
  final Color inputBg = const Color(0xFF2A2D2D);

  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _regNumController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Animations
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _orgNameController.dispose();
    _regNumController.dispose();
    _contactNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleGoogleSignup() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await AuthService.register(
        name: "Google Govt User",
        email: "googlegovt@krishinet.com",
        password: "googlepassword123",
        role: 'govt',
      );

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Registration successful via Google!'),
          backgroundColor: Color(0xFF54E167),
          behavior: SnackBarBehavior.floating,
        ),
      );

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NgoLoginScreen(),
        ),
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
      body: Stack(
        children: [
          // 1. Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [background.withValues(alpha: 0.4), background],
                ),
              ),
            ),
          ),

          // 2. Floating Particles Background
          const Positioned.fill(child: _ParticleBackground()),

          // 3. Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 40),
                          _buildRegistrationCard(),
                          const SizedBox(height: 32),
                          _buildBentoGrid(),
                          const SizedBox(height: 48),
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                    color: cardBg.withValues(
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
    return Column(
      children: [
        Text(
          'Krishinet',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Empower small-scale farmers through organized digital collaboration.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: outlineVariant.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Govt. Onboarding',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                  letterSpacing: -0.24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Register your organization to join the network.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _AnimatedFocusField(
                label: 'Organization Name',
                hint: 'Krishi Development Foundation',
                icon: Icons.corporate_fare,
                controller: _orgNameController,
              ),
              const SizedBox(height: 16),
              _AnimatedFocusField(
                label: 'Registration Number',
                hint: 'Govt-8829-2024',
                icon: Icons.badge_outlined,
                controller: _regNumController,
              ),
              const SizedBox(height: 16),
              _AnimatedFocusField(
                label: 'Contact Person',
                hint: 'Full Name',
                icon: Icons.person_outline,
                controller: _contactNameController,
              ),
              const SizedBox(height: 16),
              _AnimatedFocusField(
                label: 'Email Address',
                hint: 'contact@organization.org',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _AnimatedFocusField(
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
                obscureText: _obscurePassword,
                controller: _passwordController,
                onTogglePassword: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              const SizedBox(height: 24),

              // Register Button
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          final name = _orgNameController.text.trim();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all details'),
                              ),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          try {
                            await AuthService.register(
                              name: name,
                              email: email,
                              password: password,
                              role: 'govt',
                            );

                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Registration successful!'),
                                backgroundColor: Color(0xFF54E167),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            navigator.pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const NgoLoginScreen(),
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
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: primaryColor.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00390E),
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        'Register Officials',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 24),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Divider(color: outlineVariant.withValues(alpha: 0.2)),
              const SizedBox(height: 24),

              // Login / Socials
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already registered? ',
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
                                builder: (context) => const NgoLoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: GoogleFonts.plusJakartaSans(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          Icons.g_mobiledata,
                          Colors.white,
                          () => _handleGoogleSignup(),
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          Icons.apple,
                          Colors.white,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Apple signup is not configured.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Center(child: Icon(icon, color: color, size: 28)),
      ),
    );
  }

  Widget _buildBentoGrid() {
    return Opacity(
      opacity: 0.6,
      child: Row(
        children: [
          Expanded(
            child: _buildBentoCard(
              icon: Icons.monitor,
              title: 'REAL-TIME DATA',
              desc:
                  'Access satellite soil metrics and regional yield forecasts across your member networks.',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildBentoCard(
              icon: Icons.diversity_3,
              title: 'CO-OP SYNC',
              desc:
                  'Manage clusters of small farms with centralized distribution and resource allocation.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF122131).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      '© 2024 KRISHINET ECOSYSTEM. BUILT FOR SUSTAINABILITY.',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: onSurfaceVariant.withValues(alpha: 0.4),
      ),
    );
  }
}

// ==========================================
// ANIMATED FOCUS TEXT FIELD
// ==========================================

class _AnimatedFocusField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const _AnimatedFocusField({
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<_AnimatedFocusField> createState() => _AnimatedFocusFieldState();
}

class _AnimatedFocusFieldState extends State<_AnimatedFocusField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colors based on theme
    const Color inputBg = Color(0xFF2A2D2D);
    const Color outlineVariant = Color(0xFF3D4A3B);
    const Color primaryColor = Color(0xFF54E167);
    const Color onSurface = Color(0xFFD4E4FA);
    const Color onSurfaceVariant = Color(0xFFBCCBB7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: onSurfaceVariant,
            ),
          ),
        ),
        // Animated container to scale up when focused
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isFocused ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword && widget.obscureText,
            keyboardType: widget.keyboardType,
            style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: onSurfaceVariant.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused ? primaryColor : onSurfaceVariant,
                size: 20,
              ),
              suffixIcon:
                  widget.isPassword
                      ? GestureDetector(
                        onTap: widget.onTogglePassword,
                        child: Icon(
                          widget.obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: onSurfaceVariant,
                          size: 20,
                        ),
                      )
                      : null,
              filled: true,
              fillColor: inputBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: primaryColor),
              ),
            ),
          ),
        ),
      ],
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
  final List<_Particle> _particles = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 15; i++) {
      _particles.add(_Particle(random));
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
      painter: _ParticlePainter(_particles),
      size: Size.infinite,
    );
  }
}

class _Particle {
  double x, y;
  double vx, vy;
  double radius;
  double alpha;
  math.Random random;

  _Particle(this.random)
    : x = random.nextDouble(),
      y = random.nextDouble(),
      // Random drift direction (similar to the JS translation effect)
      vx = (random.nextDouble() - 0.5) * 0.002,
      vy = (random.nextDouble() - 0.5) * 0.002,
      radius = 2.0 + random.nextDouble() * 4.0,
      alpha = random.nextDouble() * 0.2 + 0.05;

  void update() {
    x += vx;
    y += vy;

    // Bounce off edges
    if (x < 0 || x > 1) vx *= -1;
    if (y < 0 || y > 1) vy *= -1;

    // Pulsing alpha
    alpha += (random.nextDouble() - 0.5) * 0.01;
    alpha = alpha.clamp(0.05, 0.3);
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            2.0,
          ); // blur-[2px]

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
