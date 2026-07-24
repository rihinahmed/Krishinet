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
  int _selectedIndex = 0; // Default to Farmer (0)
  int? _transitioningRoleIndex;

  // Particle Animation System
  late AnimationController _particleController;
  late List<Particle> _particles;
  final Random _random = Random();

  final List<Map<String, dynamic>> _roles = [
    {
      'title': 'Farmer',
      'icon': Icons.agriculture,
      'bgImage': 'assets/images/plants.jpg',
      'glowColor': const Color(0xFF54E167),
      'activeGradient': const LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'inactiveGradient': LinearGradient(
        colors: [
          const Color(0xFF142C1E).withValues(alpha: 0.85),
          const Color(0xFF0A1810).withValues(alpha: 0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Agri-Expert',
      'icon': Icons.psychology,
      'bgImage': 'assets/images/crop1.jpg',
      'glowColor': const Color(0xFF64B5F6),
      'activeGradient': const LinearGradient(
        colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF2196F3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'inactiveGradient': LinearGradient(
        colors: [
          const Color(0xFF13283F).withValues(alpha: 0.85),
          const Color(0xFF091420).withValues(alpha: 0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Buyer',
      'icon': Icons.shopping_cart,
      'bgImage': 'assets/images/crop3.jpg',
      'glowColor': const Color(0xFFFFB74D),
      'activeGradient': const LinearGradient(
        colors: [Color(0xFFE65100), Color(0xFFF57C00), Color(0xFFFF9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'inactiveGradient': LinearGradient(
        colors: [
          const Color(0xFF2C1E14).withValues(alpha: 0.85),
          const Color(0xFF18100A).withValues(alpha: 0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Government Officials',
      'icon': Icons.favorite,
      'bgImage': 'assets/images/crop2.jpg',
      'glowColor': const Color(0xFF4DB6AC),
      'activeGradient': const LinearGradient(
        colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF009688)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'inactiveGradient': LinearGradient(
        colors: [
          const Color(0xFF0F2624).withValues(alpha: 0.85),
          const Color(0xFF081413).withValues(alpha: 0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
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

          // 4. Smooth Transition Overlay
          Positioned.fill(
            child: _buildTransitionOverlay(),
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
          // Secure Admin Gateway
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
                  decoration: const BoxDecoration(
                    color: Color(0xFF273647), // surface-container-highest
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.security, color: primaryColor, size: 20),
                ),
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

        return RoleCard(
          title: role['title'] as String,
          icon: role['icon'] as IconData,
          isActive: isActive,
          bgImage: role['bgImage'] as String,
          activeGradient: role['activeGradient'] as Gradient,
          inactiveGradient: role['inactiveGradient'] as Gradient,
          glowColor: role['glowColor'] as Color,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      },
    );
  }

  void _startTransitionAndNavigate(Widget targetScreen) async {
    setState(() {
      _transitioningRoleIndex = _selectedIndex;
    });

    // Millisecond delay for the smooth role-based animated transition screen
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim, secAnim) => targetScreen,
          transitionsBuilder: (context, anim, secAnim, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );

      // Dismiss transition overlay shortly after navigation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _transitioningRoleIndex = null;
          });
        }
      });
    }
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
                      _startTransitionAndNavigate(const FarmerLoginScreen());
                    } else if (_selectedIndex == 1) {
                      _startTransitionAndNavigate(const ExpertLoginScreen());
                    } else if (_selectedIndex == 2) {
                      _startTransitionAndNavigate(const BuyerLoginScreen());
                    } else if (_selectedIndex == 3) {
                      _startTransitionAndNavigate(const NgoLoginScreen());
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
                    if (_selectedIndex == 0) {
                      _startTransitionAndNavigate(const FarmerSignupScreen());
                    } else if (_selectedIndex == 1) {
                      _startTransitionAndNavigate(const ExpertSignupScreen());
                    } else if (_selectedIndex == 2) {
                      _startTransitionAndNavigate(const BuyerSignupScreen());
                    } else if (_selectedIndex == 3) {
                      _startTransitionAndNavigate(const NgoSignupScreen());
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

  Widget _buildTransitionOverlay() {
    if (_transitioningRoleIndex == null) return const SizedBox.shrink();

    final role = _roles[_transitioningRoleIndex!];
    final String title = role['title'];

    Color themeColor;
    List<IconData> floatIcons;
    String statusText;
    IconData centerIcon;

    switch (_transitioningRoleIndex) {
      case 0: // Farmer
        themeColor = const Color(0xFF54E167);
        floatIcons = [Icons.eco, Icons.grass, Icons.nature, Icons.nature_people, Icons.wb_sunny];
        statusText = "Entering precision green fields...";
        centerIcon = Icons.agriculture;
        break;
      case 1: // Agri-Expert
        themeColor = const Color(0xFF64B5F6);
        floatIcons = [Icons.science, Icons.biotech, Icons.auto_awesome, Icons.psychology, Icons.insights];
        statusText = "Initiating expert environment diagnostics...";
        centerIcon = Icons.psychology;
        break;
      case 2: // Buyer
        themeColor = const Color(0xFFFFB74D);
        floatIcons = [Icons.shopping_bag, Icons.storefront, Icons.monetization_on, Icons.currency_lira, Icons.local_shipping];
        statusText = "Connecting to B2B Mokam markets...";
        centerIcon = Icons.shopping_cart;
        break;
      default: // NGO / Officials
        themeColor = const Color(0xFF4DB6AC);
        floatIcons = [Icons.favorite, Icons.handshake, Icons.security, Icons.people, Icons.account_balance];
        statusText = "Accessing administrative portal...";
        centerIcon = Icons.favorite;
        break;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Container(
            color: backgroundDeep.withValues(alpha: 0.95),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16 * val, sigmaY: 16 * val),
              child: Stack(
                children: [
                  ...List.generate(15, (index) {
                    final randomIcon = floatIcons[index % floatIcons.length];
                    final randomLeft = (index * 27) % 360 + 20.0;
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 800.0, end: -100.0),
                      duration: Duration(milliseconds: 1000 + (index * 80)),
                      builder: (context, yVal, child) {
                        return Positioned(
                          left: randomLeft,
                          top: yVal,
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(
                              randomIcon,
                              color: themeColor,
                              size: 24 + (index % 3) * 8.0,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: themeColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: themeColor.withValues(alpha: 0.3), width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeColor.withValues(alpha: 0.2),
                                      blurRadius: 40,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  centerIcon,
                                  color: themeColor,
                                  size: 64,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          title.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          statusText,
                          style: GoogleFonts.plusJakartaSans(
                            color: onSurfaceVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

// --- Custom Animated Role Selection Card ---

class RoleCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String bgImage;
  final Gradient activeGradient;
  final Gradient inactiveGradient;
  final Color glowColor;

  const RoleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.bgImage,
    required this.activeGradient,
    required this.inactiveGradient,
    required this.glowColor,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _shineController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    if (widget.isActive) {
      _floatController.repeat(reverse: true);
      _shineController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RoleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _floatController.repeat(reverse: true);
        _shineController.repeat();
      } else {
        _floatController.stop();
        _floatController.reset();
        _shineController.stop();
        _shineController.reset();
      }
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _isPressed ? 0.96 : (widget.isActive ? 1.04 : 1.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isActive
                  ? widget.glowColor
                  : Colors.white.withValues(alpha: 0.1),
              width: widget.isActive ? 2.5 : 1.0,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.glowColor.withValues(alpha: 0.35),
                      blurRadius: 25,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // 1. Background Image Layer
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: widget.isActive ? 0.35 : 0.15,
                    child: Image.asset(
                      widget.bgImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 2. Color Gradient Overlay Layer
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      gradient: widget.isActive
                          ? widget.activeGradient
                          : widget.inactiveGradient,
                    ),
                  ),
                ),

                // 3. Animated Shine Sweep Layer
                if (widget.isActive)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _shineController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ShinePainter(
                            progress: _shineController.value,
                          ),
                        );
                      },
                    ),
                  ),

                // 4. Content Layer (gently floats, centered exactly)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      final double floatOffset = widget.isActive
                          ? sin(_floatController.value * 2 * pi) * 4.0
                          : 0.0;
                      return Transform.translate(
                        offset: Offset(0, floatOffset),
                        child: child,
                      );
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon with breathing container and active scale
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: widget.isActive
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.isActive
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                                boxShadow: widget.isActive
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : [],
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Title
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

class ShinePainter extends CustomPainter {
  final double progress;

  ShinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double currentX = -width + (progress * width * 3);

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(currentX, 0, width, height));

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant ShinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
