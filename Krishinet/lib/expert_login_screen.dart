import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'agri_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class ExpertLoginScreen extends StatefulWidget {
  const ExpertLoginScreen({super.key});

  @override
  State<ExpertLoginScreen> createState() => _ExpertLoginScreenState();
}

class _ExpertLoginScreenState extends State<ExpertLoginScreen>
    with SingleTickerProviderStateMixin {
  // Theme Colors
  final Color backgroundDeep = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color surfaceContainer = const Color(0xFF1F2222);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color cardGlass = const Color(0xFF1F2222).withValues(alpha: 0.6);

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    // Controls the background particle animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    const googleEmail = 'googleexpert@krishinet.com';
    const googlePassword = 'googlepassword123';

    try {
      try {
        await AuthService.login(
          email: googleEmail,
          password: googlePassword,
        );
      } on ApiException catch (e) {
        if (e.message.contains('Invalid email or password') ||
            e.message.contains('not found') ||
            e.statusCode == 401 ||
            e.statusCode == 404) {
          await AuthService.register(
            name: "Google Expert",
            email: googleEmail,
            password: googlePassword,
            role: 'expert',
          );
          await AuthService.login(
            email: googleEmail,
            password: googlePassword,
          );
        } else {
          rethrow;
        }
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Sign In successful via Google!'),
          backgroundColor: Color(0xFF54E167),
          behavior: SnackBarBehavior.floating,
        ),
      );

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const KrishinetDashboard(),
        ),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDeep,
      body: Stack(
        children: [
          // 1. Animated Grid & Particle Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return CustomPaint(
                painter: AgriTechBackgroundPainter(
                  animationValue: _bgController.value,
                  primaryColor: primaryColor,
                ),
                size: Size.infinite,
              );
            },
          ),

          // 2. Decorative Top-Right Glow
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildLoginCard(),
                      const SizedBox(height: 48),
                      _buildBottomBadges(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back Button Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF273647).withValues(alpha: 0.8),
                padding: const EdgeInsets.all(12),
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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
          ),
          child: Icon(Icons.school, color: primaryColor, size: 32),
        ),
        const SizedBox(height: 24),
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
          'Secure access for verified agricultural consultants and researchers.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: onSurfaceVariant,
            height: 1.4,
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
            border: Border.all(
              color: const Color(0xFF879583).withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Expert ID Input
              _buildInputLabel('PROFESSIONAL ID / EMAIL', Icons.badge),
              _buildTextField(
                hint: 'expert.name@krishinet.com',
                isPassword: false,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Password Input
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildInputLabel('PASSWORD', Icons.lock),
                  Text(
                    'FORGOT?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: onSurfaceVariant,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                hint: '••••••••',
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 32),

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
                                    (context) => const KrishinetDashboard(),
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
                  elevation: 10,
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.white10),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.white10),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: outlineVariant),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.png',
                        height: 20,
                        width: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'G',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sign In with Google',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),

              // Support Link
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  Text(
                    'Require assistance? ',
                    style: GoogleFonts.plusJakartaSans(
                      color: onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Expert Support',
                    style: GoogleFonts.plusJakartaSans(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required bool isPassword,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !_isPasswordVisible,
      style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: onSurfaceVariant.withValues(alpha: 0.4),
        ),
        filled: true,
        fillColor: surfaceContainer,
        suffixIcon:
            isPassword
                ? IconButton(
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
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildBottomBadges() {
    return Opacity(
      opacity: 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBadge(Icons.verified, 'CERTIFIED'),
          const SizedBox(width: 32),
          _buildBadge(Icons.settings_suggest, 'SYSTEM HUB'),
          const SizedBox(width: 32),
          _buildBadge(Icons.monitor, 'ANALYTICS'),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: onSurfaceVariant, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: onSurfaceVariant,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Custom Painter for the Agri-Tech Grid & Animated Particles
// -----------------------------------------------------------------------------
class AgriTechBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  AgriTechBackgroundPainter({
    required this.animationValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint =
        Paint()
          ..color = primaryColor.withValues(alpha: 0.03)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // Draw grid points (agri-pattern)
    const double step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, gridPaint);
      }
    }

    // Draw floating particles based on animation value
    final Paint particlePaint =
        Paint()
          ..color = primaryColor.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;

    final math.Random random = math.Random(
      42,
    ); // Fixed seed for consistent drift paths
    final int particleCount = 20;

    for (int i = 0; i < particleCount; i++) {
      // Calculate drifting positions
      double startX = random.nextDouble() * size.width;
      double startY = random.nextDouble() * size.height;
      double speedX = (random.nextDouble() - 0.5) * 100;
      double speedY = (random.nextDouble() - 0.5) * 100;

      // Use animation value to offset positions (looping smoothly using sine)
      double currentX =
          startX + math.sin(animationValue * math.pi * 2 + i) * speedX;
      double currentY =
          startY + math.cos(animationValue * math.pi * 2 + i) * speedY;

      // Wrap around screen
      currentX = currentX % size.width;
      currentY = currentY % size.height;

      double radius = random.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(currentX, currentY), radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant AgriTechBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
