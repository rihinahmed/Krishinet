import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buyer_signup_screen.dart';
import 'buyer_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class BuyerLoginScreen extends StatefulWidget {
  const BuyerLoginScreen({super.key});

  @override
  State<BuyerLoginScreen> createState() => _BuyerLoginScreenState();
}

class _BuyerLoginScreenState extends State<BuyerLoginScreen> {
  // Theme Colors from Tailwind config
  final Color background = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color surface = const Color(0xFF1F2222);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color onSurface = const Color(0xFFD4E4FA);

  bool _obscurePassword = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Atmospheric Orbs
          Positioned(
            top: -100,
            right: -50,
            child: _buildBlurOrb(size: 300, opacity: 0.05),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: _buildBlurOrb(size: 250, opacity: 0.05),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Header
                    Text(
                      'Krishinet',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BUYER ECOSYSTEM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceVariant.withValues(alpha: 0.8),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Login Glass Card
                    _buildLoginCard(),

                    const SizedBox(height: 48),

                    // Feature Cards (Responsive stack for mobile)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Column(
                        children: [
                          _buildFeatureCard(
                            icon: Icons.verified_user_outlined,
                            title: 'Verified Sources',
                            subtitle: 'Direct farm-to-table traceability',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            icon: Icons.payments_outlined,
                            title: 'Secure Escrow',
                            subtitle: 'Funds released upon delivery',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            icon: Icons.speed_outlined,
                            title: 'Smart Logistics',
                            subtitle: 'Real-time supply chain tracking',
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

  Widget _buildLoginCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome back',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log in to manage your marketplace orders.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Email Input
                _buildInputField(
                  label: 'Email or Mobile',
                  hint: 'Enter your registered contact',
                  icon: Icons.alternate_email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password Input
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
                      size: 20,
                    ),
                  ),
                ),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: Text(
                      'Forgot?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),

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
                                      (context) => const KrishinetPreviewApp(),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.login, size: 20),
                    ],
                  ),
                ),

                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
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
                        icon: Icons.apple,
                        label: 'Apple',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Join Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.plusJakartaSans(
                        color: onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
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
                      },
                      child: Text(
                        'Join as Buyer',
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
    Widget? trailing,
    TextEditingController? controller,
    TextInputType? keyboardType,
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && _obscurePassword,
          style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariant.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(icon, color: onSurfaceVariant, size: 20),
            suffixIcon: trailing,
            filled: true,
            fillColor: surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
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
      onPressed: () {},
      icon: Icon(icon, color: primaryColor, size: 24),
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1C2D).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
