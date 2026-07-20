import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'expert_login_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class ExpertSignupScreen extends StatefulWidget {
  const ExpertSignupScreen({super.key});

  @override
  State<ExpertSignupScreen> createState() => _ExpertSignupScreenState();
}

class _ExpertSignupScreenState extends State<ExpertSignupScreen>
    with SingleTickerProviderStateMixin {
  // Theme Colors matching the Krishinet design system
  final Color backgroundDeep = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color inputSurface = const Color(0xFF2A2D2D);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color cardGlass = const Color(0xFF1F2222).withValues(alpha: 0.7);

  late AnimationController _bgController;

  // Form State
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isPasswordVisible = false;
  String _selectedSpecialization = 'Soil Health';
  final List<String> _specializations = [
    'Soil Health',
    'Pest Management',
    'Precision Irrigation',
    'Agronomy',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _certController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _certController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all details')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    try {
      await AuthService.register(
        name: name,
        email: email,
        password: password,
        role: 'expert',
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        // Reset success state after a few seconds and navigate
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() => _isSuccess = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ExpertLoginScreen()),
          );
        }
      }
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red[800]),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDeep,
      body: Stack(
        children: [
          // 1. Animated Background Layer
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return CustomPaint(
                painter: ExpertBgPainter(
                  animationValue: _bgController.value,
                  primaryColor: primaryColor,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Gradient Overlay to blend particles
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [backgroundDeep, Colors.transparent, backgroundDeep],
              ),
            ),
          ),

          // 2. Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448), // max-w-md
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildSignupCard(),
                      const SizedBox(height: 48),
                      _buildBottomFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back Button
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
          'Join our network of precision agricultural experts.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: onSurfaceVariant,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: cardGlass,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Atmospheric Overlay Image Placeholder
              Container(
                height: 128,
                decoration: const BoxDecoration(
                  color: Color(0xFF152A20), // Dark verdant green placeholder
                  image: DecorationImage(
                    // Replace this with your actual asset or network image
                    image: AssetImage('images/plants.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFF1F2222), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Form Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildInputField(
                      label: 'Full Name',
                      hint: 'Dr. Sarah Jenkins',
                      icon: Icons.person,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),

                    // FIX: Stacked Layout for Specialization & ID (Prevents Overflow)
                    _buildSpecializationDropdown(),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Certification ID',
                      hint: 'CERT-9021',
                      isUppercase: true,
                      controller: _certController,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      label: 'Professional Email',
                      hint: 'sarah.j@agri-inst.org',
                      icon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      label: 'Create Password',
                      hint: '••••••••',
                      icon: Icons.lock,
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 24),

                    // CTA Button
                    ElevatedButton(
                      onPressed:
                          (_isLoading || _isSuccess) ? null : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSuccess ? const Color(0xFF2CC04B) : primaryColor,
                        disabledBackgroundColor:
                            _isSuccess
                                ? const Color(0xFF2CC04B)
                                : primaryColor.withValues(alpha: 0.5),
                        foregroundColor: const Color(0xFF00390E),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: primaryColor.withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF00390E),
                                ),
                              ),
                            )
                          else if (_isSuccess)
                            const Icon(Icons.check_circle, size: 22)
                          else ...[
                            Text(
                              'Apply as Expert',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                          if (_isLoading) ...[
                            const SizedBox(width: 12),
                            Text(
                              'Processing...',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else if (_isSuccess) ...[
                            const SizedBox(width: 12),
                            Text(
                              'Application Sent',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.plusJakartaSans(
                            color: onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExpertLoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign in here',
                            style: GoogleFonts.plusJakartaSans(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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

  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool isUppercase = false,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
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
          obscureText: isPassword && !_isPasswordVisible,
          keyboardType: keyboardType,
          textCapitalization:
              isUppercase
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
          style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(color: outlineVariant),
            filled: true,
            fillColor: inputSurface,
            prefixIcon:
                icon != null
                    ? Icon(icon, color: onSurfaceVariant, size: 20)
                    : null,
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: onSurfaceVariant.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      onPressed:
                          () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primaryColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecializationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Specialization',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: onSurfaceVariant,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedSpecialization,
          dropdownColor: const Color(0xFF1F2222),
          style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 14),
          icon: Icon(Icons.arrow_drop_down, color: onSurfaceVariant),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primaryColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          items:
              _specializations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedSpecialization = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBottomFooter() {
    return Opacity(
      opacity: 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterBadge(Icons.verified, 'Identity Verified'),
              const SizedBox(width: 32),
              _buildFooterBadge(Icons.no_encryption, 'Secure Encryption'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2024 KRISHINET PRECISION SYSTEMS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
              color: outlineVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: onSurfaceVariant, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Reusable Painter for Background Particles (Shared aesthetic)
// -----------------------------------------------------------------------------
class ExpertBgPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  ExpertBgPainter({required this.animationValue, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint particlePaint =
        Paint()
          ..color = primaryColor.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;

    final Paint connectionPaint =
        Paint()
          ..color = primaryColor.withValues(alpha: 0.03)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final math.Random random = math.Random(100);
    final int particleCount = 25;
    List<Offset> points = [];

    for (int i = 0; i < particleCount; i++) {
      double startX = random.nextDouble() * size.width;
      double startY = random.nextDouble() * size.height;

      // Calculate slow drift
      double driftX = math.sin(animationValue * math.pi * 2 + i) * 30;
      double driftY = math.cos(animationValue * math.pi * 2 + i) * 30;

      double currentX = (startX + driftX) % size.width;
      double currentY = (startY + driftY) % size.height;

      if (currentX < 0) currentX += size.width;
      if (currentY < 0) currentY += size.height;

      points.add(Offset(currentX, currentY));

      double radius = random.nextDouble() * 2 + 1.5;
      canvas.drawCircle(points.last, radius, particlePaint);
    }

    // Draw tech-like connections between close particles
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        double distance = (points[i] - points[j]).distance;
        if (distance < 120) {
          canvas.drawLine(points[i], points[j], connectionPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ExpertBgPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
