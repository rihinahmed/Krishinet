import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'farmer_login_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class FarmerSignupScreen extends StatefulWidget {
  const FarmerSignupScreen({super.key});

  @override
  State<FarmerSignupScreen> createState() => _FarmerSignupScreenState();
}

class _FarmerSignupScreenState extends State<FarmerSignupScreen>
    with SingleTickerProviderStateMixin {
  // Theme Colors
  final Color backgroundDeep = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color surfaceContainer = const Color(0xFF122131);
  final Color surfaceContainerHigh = const Color(0xFF1C2B3C);
  final Color outlineVariant = const Color(0xFF3D4A3B);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color onSurface = const Color(0xFFD4E4FA);
  final Color cardGlass = const Color(0xFF1F2222).withValues(alpha: 0.7);

  bool _isPasswordVisible = false;
  bool _showSuccessModal = false;
  String? _selectedCrop;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
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
    try {
      // Mock email for registration logic as farmer role baseline
      final email = "${phone.replaceAll('+', '')}@krishinet.com";
      await AuthService.register(
        name: name,
        email: email,
        password: password,
        role: 'farmer',
        phone: phone,
      );
      setState(() {
        _showSuccessModal = true;
      });
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
      backgroundColor: backgroundDeep,
      body: Stack(
        children: [
          // 1. Atmospheric Background Animation
          _buildAtmosphericBackground(),

          // 2. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildSignupForm(context),
                      const SizedBox(height: 32),
                      _buildFooterCompliance(),
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
                backgroundColor: const Color(0xFF273647),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),

          // 3. Success Modal Overlay
          if (_showSuccessModal) _buildSuccessModal(),
        ],
      ),
    );
  }

  Widget _buildAtmosphericBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 120,
                            spreadRadius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF273647).withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF273647).withValues(alpha: 0.3),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
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
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: outlineVariant),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 20,
              ),
            ],
          ),
          child: Icon(Icons.agriculture, color: primaryColor, size: 32),
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
          'Cultivating the Future through Precision',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardGlass,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Farmer Registration',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Start your journey with data-driven cultivation.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              _buildInputLabel('FULL NAME'),
              _buildTextField(
                hint: 'Enter your full name',
                icon: Icons.person,
                controller: _nameController,
              ),
              const SizedBox(height: 16),

              // Location
              _buildInputLabel('FARM LOCATION'),
              _buildTextField(
                hint: 'City, State or Region',
                icon: Icons.location_on,
                controller: _locationController,
              ),
              const SizedBox(height: 16),

              // Primary Crop Dropdown
              _buildInputLabel('PRIMARY CROP'),
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                dropdownColor: surfaceContainerHigh,
                icon: Icon(
                  Icons.expand_more,
                  color: outlineVariant.withValues(alpha: 0.8),
                ),
                style: GoogleFonts.plusJakartaSans(
                  color: onSurface,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.energy_savings_leaf,
                    color: outlineVariant.withValues(alpha: 0.8),
                  ),
                  filled: true,
                  fillColor: surfaceContainer,
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
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                hint: Text(
                  'Select your main crop',
                  style: GoogleFonts.plusJakartaSans(color: outlineVariant),
                ),
                items: const [
                  DropdownMenuItem(value: 'wheat', child: Text('Wheat')),
                  DropdownMenuItem(value: 'rice', child: Text('Rice')),
                  DropdownMenuItem(value: 'corn', child: Text('Corn / Maize')),
                  DropdownMenuItem(value: 'cotton', child: Text('Cotton')),
                  DropdownMenuItem(
                    value: 'sugarcane',
                    child: Text('Sugarcane'),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text('Other / Multi-crop'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCrop = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Mobile Number
              _buildInputLabel('MOBILE NUMBER'),
              _buildTextField(
                hint: '+8801700000000',
                icon: Icons.call,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              const SizedBox(height: 16),

              // Password
              _buildInputLabel('CREATE PASSWORD'),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: GoogleFonts.plusJakartaSans(
                  color: onSurface,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Minimum 8 characters',
                  hintStyle: GoogleFonts.plusJakartaSans(color: outlineVariant),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: outlineVariant.withValues(alpha: 0.8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: outlineVariant.withValues(alpha: 0.8),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: surfaceContainer,
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
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 28),

              // Join Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: const Color(0xFF00390E), // on-primary
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: primaryColor.withValues(alpha: 0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00390E),
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        'Join Krishinet',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
                    style: GoogleFonts.plusJakartaSans(color: onSurfaceVariant),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const FarmerLoginScreen(),
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
                      'Sign In',
                      style: GoogleFonts.plusJakartaSans(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: primaryColor,
                      ),
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

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onSurfaceVariant,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.plusJakartaSans(color: onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: outlineVariant),
        prefixIcon: Icon(icon, color: outlineVariant.withValues(alpha: 0.8)),
        filled: true,
        fillColor: surfaceContainer,
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
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildFooterCompliance() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 1, width: 32, color: outlineVariant),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'VERIFIED PLATFORM',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onSurfaceVariant.withValues(alpha: 0.7),
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Container(height: 1, width: 32, color: outlineVariant),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildComplianceBadge(
                Icons.verified_user,
                'Secure Data\nEncryption',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildComplianceBadge(
                Icons.cloud_done,
                'Cloud Insight\nReady',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComplianceBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(
          0xFF0D1C2D,
        ).withValues(alpha: 0.5), // surface-container-low
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: onSurfaceVariant,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessModal() {
    return Container(
      color: backgroundDeep.withValues(alpha: 0.9),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: cardGlass,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: primaryColor,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Aboard!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your farmer account has been successfully initialized. Preparing your personalized dashboard...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showSuccessModal = false;
                      });
                      // Navigate to dashboard here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: const Color(0xFF00390E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
