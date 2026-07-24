import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'core/utils/constants.dart';

class GovtDashboardScreen extends StatefulWidget {
  const GovtDashboardScreen({super.key});

  @override
  State<GovtDashboardScreen> createState() => _GovtDashboardScreenState();
}

class _GovtDashboardScreenState extends State<GovtDashboardScreen> {
  // Theme Colors matching HTML tailwind config
  final Color baseBackground = const Color(0xFF051424);
  final Color primaryColor = const Color(0xFF54E167);
  final Color primaryContainerColor = const Color(0xFF2CC04B);
  final Color surfaceContainerColor = const Color(0xFF122131);
  final Color surfaceContainerHighColor = const Color(0xFF1C2B3C);
  final Color onSurfaceVariantColor = const Color(0xFFBCCBB7);

  int _selectedTab = 0; // 0: Dash, 1: Chats, 2: Policy, 3: Profile

  // Temp lists of subsidies
  final List<Map<String, dynamic>> _subsidies = [
    {
      'title': 'Seed Subsidy #882',
      'subtitle': 'Karnal District • 12 Oct',
      'status': 'Pending',
    },
    {
      'title': 'Irrigation Pump #901',
      'subtitle': 'Ambala District • 11 Oct',
      'status': 'Approved',
    },
    {
      'title': 'Fertilizer Credit #771',
      'subtitle': 'Sonepat District • 10 Oct',
      'status': 'Pending',
    },
  ];

  // Controller for layout text field
  final TextEditingController _directiveController = TextEditingController();

  void _publishDirective() {
    if (_directiveController.text.trim().isEmpty) return;

    // Simulate publication success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Directive Published: "${_directiveController.text}"',
                style: GoogleFonts.plusJakartaSans(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: surfaceContainerHighColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    _directiveController.clear();
  }

  void _showSubsidyApprovalSheet(int index) {
    final request = _subsidies[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceContainerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request['title']!,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request['subtitle']!,
                    style: GoogleFonts.plusJakartaSans(
                      color: onSurfaceVariantColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 16),
                  Text(
                    "This subsidy request covers high-yield seed provisioning and modern implement distribution for rural farmers in this sector. Verify regional inspector reports before signing.",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (request['status'] == 'Pending') ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _subsidies[index]['status'] = 'Approved';
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${request['title']} has been approved.",
                                  ),
                                  backgroundColor: primaryContainerColor,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: const Color(0xFF00390E),
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Approve Request",
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _subsidies[index]['status'] = 'Rejected';
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Request rejected."),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            minimumSize: const Size(100, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Reject",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            request['status'] == 'Approved'
                                ? primaryColor.withValues(alpha: 0.1)
                                : Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Status: ${request['status']!.toUpperCase()}",
                        style: GoogleFonts.plusJakartaSans(
                          color:
                              request['status'] == 'Approved'
                                  ? primaryColor
                                  : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFieldReportSheet(String region, String desc, double healthVal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceContainerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Region Telemetry: $region",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              _buildMetricRow(
                "Vegetation Index (NDVI)",
                "${(healthVal * 100).toInt()}% Health",
              ),
              const SizedBox(height: 12),
              _buildMetricRow(
                "Soil Moisture Sensor",
                healthVal > 0.8 ? "45% (Optimal)" : "22% (Dry/Critical)",
              ),
              const SizedBox(height: 12),
              _buildMetricRow("Drone Patrol Status", "Completed today"),
              const SizedBox(height: 20),
              Text(
                "Overview: $desc",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: onSurfaceVariantColor,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: baseBackground,
      body: Stack(
        children: [
          // Background Animation Systems
          const Positioned.fill(child: _GovtParticleBackground()),

          Row(
            children: [
              // Side Nav (Desktop)
              if (isDesktop) _buildSideNav(),

              // Canvas Content
              Expanded(
                child: SafeArea(
                  bottom: !isDesktop, // No safety overlay behind bottom navbar
                  child: Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: AnimationLimiter(
                            child: _buildSelectedPageContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNavBar(),
    );
  }

  // Selected tab display
  Widget _buildSelectedPageContent() {
    switch (_selectedTab) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return _buildChatsPage();
      case 2:
        return _buildPolicyPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomeDashboard();
    }
  }

  // Page 1: Dashboard Home Layout
  Widget _buildHomeDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 600),
        childAnimationBuilder:
            (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
        children: [
          // Stats row
          _buildStatsRow(),
          const SizedBox(height: 16),

          // Communication Hub & Directive Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildCommunicationHub()),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: _buildRightWidgetsPanel()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildCommunicationHub(),
                    const SizedBox(height: 16),
                    _buildRightWidgetsPanel(),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Field Reports
          _buildFieldReportsSection(),
        ],
      ),
    );
  }

  // Page 2: Inbox & Live Chat view
  Widget _buildChatsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Live Inbox', Icons.forum),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildChatThreadTile(
                name: 'Dr. Aman Singh',
                caption: 'Soil Specialist • Online',
                message:
                    'I approved the soil samples for Karnal field 4B. The pH levels look excellent.',
                time: 'Just now',
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBMiuEB8Nu3x-QL_mb70eRQS7LYxwHlMIEAYElE-hEHg69qmLcE3rAbsSerAZn8a8X0vhhTioivtn5eT5Oglh07gOUbq-82xTrY3TB_c6m_nlhDrlYI7XKgWxFMuSgNYhyTg9JHhAYAT0OncW3ISM4do-QT1SpELozfVTalffywrsyMaLw4xpax9VGz7lfCR7dL6l14kJNkKu9lM05Z9lpT6ozvXmZDEe2VXu9KQ5hJBqymCTQOgkZ9fvU9Jk9HHr7IhslPBVyMzrPq',
              ),
              const Divider(color: Colors.white10),
              _buildChatThreadTile(
                name: 'Sarah Mitchell',
                caption: 'Pest Control Specialist',
                message:
                    'Recommended pesticide list updated for the new regional directives.',
                time: '1h ago',
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAxtNkiVFovr5HU6vijSMCpckn1ZQ8ut3RHY0AsKbtEPyrfMHEmNfA6LoKlfkwYGB05dZHXmpvjNboThQS-w0-3Bobiw1wDcy6USe-inn2SbBPQKcP9VcyI26FNITgfBedGbpR4ktZJVCYbC3AjpkUlqedIxW3yaWaoj0bkHUuijoVtDII0gJ1laBEmEQ52VS9dYsjjxdqItnNOiaN_qVu2UczrD5BCrXeSv8RPs9j7x9IeStRuH5WdpWlMzIYqQ2amCwms4ubI-Vrk',
              ),
              const Divider(color: Colors.white10),
              _buildChatThreadTile(
                name: 'Rajesh Kumar',
                caption: 'Farmer (Punjab East)',
                message:
                    'Thank you for the quick subsidy release order. Will apply it tomorrow.',
                time: '2h ago',
                isFarmer: true,
              ),
              const Divider(color: Colors.white10),
              _buildChatThreadTile(
                name: 'Anita Desai',
                caption: 'Farmer (Central Zone)',
                message:
                    'Blight disease spots noticed on cotton leaves. Requesting immediate verification.',
                time: '1d ago',
                isFarmer: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Page 3: Policy portal & Directives
  Widget _buildPolicyPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Policy Directives & Enactments', Icons.gavel),
        const SizedBox(height: 16),
        _buildDirectiveCard(),
        const SizedBox(height: 16),
        _buildSectionHeader('Recent Subsidies Logs', Icons.payments),
        const SizedBox(height: 16),
        _buildSubsidyTableCard(),
      ],
    );
  }

  // Page 4: User Admin Profile setup
  Widget _buildProfilePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Officer Profile Control', Icons.person),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            (!AppConstants.isTesting)
                                ? Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBeiu1xZ9N-Bi6-bT9-XKQiM7SlObrQTyooNVdy36y5oQM5UhlM0xj3RIaj_AADkkimNpLrbUxXqExDCJGoEVY0BtX79i25UL5K7XgJwkg1JIXjnteE7BtC9qlWaDnf95ObcZxhcQquoxB-QFaNbdQ90i3mtDhkKYF_sgQ8XYWu6JRWDoV-UJiiyUvcqIQfpgl2U0pGLEEszZiuZSyN_mgeAaaGMNzUM_O1sLKELOxXeTXvmdpoE9GsGpJUm90Y2i8p5bB91j5Wflnq',
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: surfaceContainerHighColor,
                                        child: Icon(
                                          Icons.person,
                                          size: 64,
                                          color: onSurfaceVariantColor,
                                        ),
                                      ),
                                )
                                : Container(
                                  color: surfaceContainerHighColor,
                                  child: Icon(
                                    Icons.person,
                                    size: 64,
                                    color: onSurfaceVariantColor,
                                  ),
                                ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 18,
                          color: Color(0xFF00390E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Director General Admin',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Ministry of Agriculture • Govt. of India',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: onSurfaceVariantColor,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              _buildProfileDetailRow('Officer ID', 'MINAGRI-8839082'),
              _buildProfileDetailRow(
                'Regional Jurisdiction',
                'North-West Division',
              ),
              _buildProfileDetailRow(
                'Security Enclave',
                'Level-IV Security Encrypted',
              ),
              _buildProfileDetailRow('Current IP Route', '10.244.38.109'),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Secure Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF93000A),
                  foregroundColor: const Color(0xFFFFDAD6),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariantColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: baseBackground.withValues(alpha: 0.8),
        border: const Border(
          bottom: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      (!AppConstants.isTesting)
                          ? Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBeiu1xZ9N-Bi6-bT9-XKQiM7SlObrQTyooNVdy36y5oQM5UhlM0xj3RIaj_AADkkimNpLrbUxXqExDCJGoEVY0BtX79i25UL5K7XgJwkg1JIXjnteE7BtC9qlWaDnf95ObcZxhcQquoxB-QFaNbdQ90i3mtDhkKYF_sgQ8XYWu6JRWDoV-UJiiyUvcqIQfpgl2U0pGLEEszZiuZSyN_mgeAaaGMNzUM_O1sLKELOxXeTXvmdpoE9GsGpJUm90Y2i8p5bB91j5Wflnq',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: surfaceContainerHighColor,
                                  child: Icon(
                                    Icons.person,
                                    size: 24,
                                    color: onSurfaceVariantColor,
                                  ),
                                ),
                          )
                          : Container(
                            color: surfaceContainerHighColor,
                            child: Icon(
                              Icons.person,
                              size: 24,
                              color: onSurfaceVariantColor,
                            ),
                          ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Krishinet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Min. of Agriculture • Admin Portal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: onSurfaceVariantColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: primaryColor),
                onPressed: () {},
                splashRadius: 20,
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: primaryColor),
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
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

  // Desktop sidebar nav
  Widget _buildSideNav() {
    return Container(
      width: 84,
      decoration: BoxDecoration(
        color: surfaceContainerColor.withValues(alpha: 0.5),
        border: const Border(
          right: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Icon(Icons.eco, color: primaryColor, size: 36),
          const SizedBox(height: 48),
          Expanded(
            child: Column(
              children: [
                _buildSideNavItem(0, Icons.dashboard, 'Dash'),
                const SizedBox(height: 24),
                _buildSideNavItem(1, Icons.forum, 'Chats'),
                const SizedBox(height: 24),
                _buildSideNavItem(2, Icons.gavel, 'Policy'),
                const SizedBox(height: 24),
                _buildSideNavItem(3, Icons.person, 'Profile'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSideNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? primaryContainerColor.withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? primaryColor.withValues(alpha: 0.3)
                    : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: isSelected ? primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile navigation bar
  Widget _buildBottomNavBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        color: surfaceContainerColor.withValues(alpha: 0.9),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: onSurfaceVariantColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Chats'),
            BottomNavigationBarItem(icon: Icon(Icons.gavel), label: 'Policy'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // Stats cards rendering
  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              _buildStatCard(
                '1,402',
                'Active Subsidies',
                '+12%',
                Icons.payments,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                '342',
                'Expert Verifications',
                '98%',
                Icons.verified_user,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                '89,201',
                'Farmer Reach',
                '2.4M',
                Icons.groups,
                Colors.green,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildStatCard(
                  '1,402',
                  'Active Subsidies',
                  '+12%',
                  Icons.payments,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '342',
                  'Expert Verifications',
                  '98%',
                  Icons.verified_user,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '89,201',
                  'Farmer Reach',
                  '2.4M',
                  Icons.groups,
                  Colors.green,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(
    String mainValue,
    String label,
    String tag,
    IconData icon,
    Color color,
  ) {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: primaryColor, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryContainerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            mainValue,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariantColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Communication hub details
  Widget _buildCommunicationHub() {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.forum, color: primaryColor, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Communication Hub',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '12 New',
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'AGRI-EXPERTS',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariantColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildExpertQuickTile(
                  name: 'Dr. Aman Singh',
                  specialty: 'Soil Specialist',
                  url:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBMiuEB8Nu3x-QL_mb70eRQS7LYxwHlMIEAYElE-hEHg69qmLcE3rAbsSerAZn8a8X0vhhTioivtn5eT5Oglh07gOUbq-82xTrY3TB_c6m_nlhDrlYI7XKgWxFMuSgNYhyTg9JHhAYAT0OncW3ISM4do-QT1SpELozfVTalffywrsyMaLw4xpax9VGz7lfCR7dL6l14kJNkKu9lM05Z9lpT6ozvXmZDEe2VXu9KQ5hJBqymCTQOgkZ9fvU9Jk9HHr7IhslPBVyMzrPq',
                ),
                const SizedBox(width: 12),
                _buildExpertQuickTile(
                  name: 'Sarah Mitchell',
                  specialty: 'Pest Control',
                  url:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAxtNkiVFovr5HU6vijSMCpckn1ZQ8ut3RHY0AsKbtEPyrfMHEmNfA6LoKlfkwYGB05dZHXmpvjNboThQS-w0-3Bobiw1wDcy6USe-inn2SbBPQKcP9VcyI26FNITgfBedGbpR4ktZJVCYbC3AjpkUlqedIxW3yaWaoj0bkHUuijoVtDII0gJ1laBEmEQ52VS9dYsjjxdqItnNOiaN_qVu2UczrD5BCrXeSv8RPs9j7x9IeStRuH5WdpWlMzIYqQ2amCwms4ubI-Vrk',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'FARMER OUTREACH',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariantColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildOutreachListItem(
            'Rajesh Kumar',
            'Subsidy query regarding the new tractor scheme in Punjab...',
            '2m ago',
          ),
          const Divider(color: Colors.white10),
          _buildOutreachListItem(
            'Anita Desai',
            'Reported crop blight in Maharashtra district 04...',
            '1h ago',
          ),
        ],
      ),
    );
  }

  Widget _buildExpertQuickTile({
    required String name,
    required String specialty,
    required String url,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceContainerHighColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: surfaceContainerColor,
            ),
            child: ClipOval(
              child:
                  (!AppConstants.isTesting)
                      ? Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: surfaceContainerHighColor,
                              child: Icon(
                                Icons.person,
                                size: 18,
                                color: onSurfaceVariantColor,
                              ),
                            ),
                      )
                      : Container(
                        color: surfaceContainerHighColor,
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: onSurfaceVariantColor,
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  specialty,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutreachListItem(String name, String querySnippet, String time) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = 1; // Open Chats view
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryContainerColor.withValues(alpha: 0.15),
              ),
              child: Icon(Icons.person, color: primaryColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          color: onSurfaceVariantColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    querySnippet,
                    style: GoogleFonts.plusJakartaSans(
                      color: onSurfaceVariantColor,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: primaryColor, size: 18),
          ],
        ),
      ),
    );
  }

  // Right side panel (Directive & Subsidies)
  Widget _buildRightWidgetsPanel() {
    return Column(
      children: [
        _buildDirectiveCard(),
        const SizedBox(height: 16),
        _buildSubsidyTableCard(),
      ],
    );
  }

  Widget _buildDirectiveCard() {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel, color: primaryColor, size: 22),
              const SizedBox(width: 8),
              Text(
                'New Directive',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Broadcast policy updates to all verified farmers and regional hubs instantly.',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariantColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _directiveController,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Enter policy broadcast directive details...',
              hintStyle: GoogleFonts.plusJakartaSans(
                color: onSurfaceVariantColor.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              filled: true,
              fillColor: surfaceContainerHighColor.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _publishDirective,
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Publish Directive'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: const Color(0xFF00390E),
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsidyTableCard() {
    return _buildGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBSIDY REQUESTS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: onSurfaceVariantColor,
                    letterSpacing: 1.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTab = 2; // Open Policy tab which lists requests
                    });
                  },
                  child: Text(
                    'View All',
                    style: GoogleFonts.plusJakartaSans(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subsidies.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(color: Colors.white10, height: 1),
            itemBuilder: (context, index) {
              final request = _subsidies[index];
              final bool isApproved = request['status'] == 'Approved';

              return GestureDetector(
                onTap: () => _showSubsidyApprovalSheet(index),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request['title']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                request['subtitle']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: onSurfaceVariantColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isApproved
                                    ? primaryColor.withValues(alpha: 0.1)
                                    : Colors.yellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            request['status']!,
                            style: GoogleFonts.plusJakartaSans(
                              color:
                                  isApproved
                                      ? primaryColor
                                      : Colors.yellow[600],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Field reports section
  Widget _buildFieldReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Regional Field Reports', Icons.map),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      'Punjab East',
                      'Wheat crops are showing exceptional growth. Irrigation levels optimal for current season.',
                      0.92,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB_xUJKGyMEOXDQf9FCH9jvg0MBY5qaM89cO1KFue5rOfm16PM06wRUO4UntDsCgjFiECp6sPBdQhkwLo6c_jRRhXeslaZQpVB3IKrZQgRBnwEJF2ZdM7R8s1WRyK-kzwl9Su_fpYqAX8MWK_acSz6ddrfFokX2zXieSQ3fgCcpcJI7QvfwOQO9EKGAOwYH6tCLWoNVCMe7zYZfdr7tz4hLO1obTWBtyg935MXcqoyFaJm107dL1Pe4ENTo5xUDcEjStsQt-_RutBR4',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      'Haryana Central',
                      'Cotton yield predicted to exceed annual targets by 15%. Expert monitoring ongoing.',
                      0.85,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCw47mYyIQ2aNC5OxRDmHSFwuZP25YpCQOPxxHWupndAKwNnNoyyvMhRwHPY4Liogbfn3iMfOGP-p_nlXCn7TFwmSjGOuUcwQ29R7IJbVt4ImKb6Vw7EEe02sD9N5YImN58SvPFdPrmHIKddsyP7k4vPOVOnxyND7A08M6W7u1Gcu3X3Clfg39eNgYXb-kGAzuj19AxCkqe0tgG5WDEthxmGq2f88ilkJ8cTpV7WgfJ2qXA5baGOjdVLDhC6I4K7AAauOY0ez2ohP1F',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      'Rajasthan West',
                      'Arid conditions worsening. Emergency water distribution directive pending approval.',
                      0.64,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA-4Otj64CN55i3LZfCWXAPr06x5whVIMmiuiBqv_2iaAsVmAVP6jtL1Nzucrc9-bcyHagickBRBmlFqDw3FWj_AVJ7Q7f1sQYJ_XyhyxJ2DrLj9_cYTfJoOhfzovy_EZds6TSOVOrIeRCi9VJqjBSDqoKv063Dzu6fwAlaR9dTWT0AFwiaUlkwvf3yVPf6JusuNTuQ6czd4dOdTPaFAIW0it1j0bC60Eh2o34nH6UhLGflOdkCx039eQtSr7c3p0m95wTJUu5qbkqj',
                      warning: true,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildReportCard(
                    'Punjab East',
                    'Wheat crops are showing exceptional growth. Irrigation levels optimal for current season.',
                    0.92,
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB_xUJKGyMEOXDQf9FCH9jvg0MBY5qaM89cO1KFue5rOfm16PM06wRUO4UntDsCgjFiECp6sPBdQhkwLo6c_jRRhXeslaZQpVB3IKrZQgRBnwEJF2ZdM7R8s1WRyK-kzwl9Su_fpYqAX8MWK_acSz6ddrfFokX2zXieSQ3fgCcpcJI7QvfwOQO9EKGAOwYH6tCLWoNVCMe7zYZfdr7tz4hLO1obTWBtyg935MXcqoyFaJm107dL1Pe4ENTo5xUDcEjStsQt-_RutBR4',
                  ),
                  const SizedBox(height: 12),
                  _buildReportCard(
                    'Haryana Central',
                    'Cotton yield predicted to exceed annual targets by 15%. Expert monitoring ongoing.',
                    0.85,
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCw47mYyIQ2aNC5OxRDmHSFwuZP25YpCQOPxxHWupndAKwNnNoyyvMhRwHPY4Liogbfn3iMfOGP-p_nlXCn7TFwmSjGOuUcwQ29R7IJbVt4ImKb6Vw7EEe02sD9N5YImN58SvPFdPrmHIKddsyP7k4vPOVOnxyND7A08M6W7u1Gcu3X3Clfg39eNgYXb-kGAzuj19AxCkqe0tgG5WDEthxmGq2f88ilkJ8cTpV7WgfJ2qXA5baGOjdVLDhC6I4K7AAauOY0ez2ohP1F',
                  ),
                  const SizedBox(height: 12),
                  _buildReportCard(
                    'Rajasthan West',
                    'Arid conditions worsening. Emergency water distribution directive pending approval.',
                    0.64,
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA-4Otj64CN55i3LZfCWXAPr06x5whVIMmiuiBqv_2iaAsVmAVP6jtL1Nzucrc9-bcyHagickBRBmlFqDw3FWj_AVJ7Q7f1sQYJ_XyhyxJ2DrLj9_cYTfJoOhfzovy_EZds6TSOVOrIeRCi9VJqjBSDqoKv063Dzu6fwAlaR9dTWT0AFwiaUlkwvf3yVPf6JusuNTuQ6czd4dOdTPaFAIW0it1j0bC60Eh2o34nH6UhLGflOdkCx039eQtSr7c3p0m95wTJUu5qbkqj',
                    warning: true,
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildReportCard(
    String region,
    String desc,
    double healthVal,
    String imageUrl, {
    bool warning = false,
  }) {
    Color valColor = warning ? Colors.red : primaryColor;
    return GestureDetector(
      onTap: () => _showFieldReportSheet(region, desc, healthVal),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceContainerColor.withValues(alpha: 0.6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 140,
                    width: double.infinity,
                    child:
                        (!AppConstants.isTesting)
                            ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: surfaceContainerHighColor,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: surfaceContainerHighColor,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.terrain,
                                      size: 48,
                                      color: onSurfaceVariantColor,
                                    ),
                                  ),
                            )
                            : Container(
                              color: surfaceContainerHighColor,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.terrain,
                                size: 48,
                                color: onSurfaceVariantColor,
                              ),
                            ),
                  ),
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          surfaceContainerColor.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: Text(
                      region,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Health Index',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: onSurfaceVariantColor,
                          ),
                        ),
                        Text(
                          '${(healthVal * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: valColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: surfaceContainerHighColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: healthVal,
                        child: Container(
                          decoration: BoxDecoration(
                            color: valColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      desc,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: onSurfaceVariantColor,
                        height: 1.4,
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
  }

  // Common UI Layout builders
  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: surfaceContainerColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Chats Thread UI Builders
  Widget _buildChatThreadTile({
    required String name,
    required String caption,
    required String message,
    required String time,
    String? avatarUrl,
    bool isFarmer = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isFarmer
                      ? primaryContainerColor.withValues(alpha: 0.15)
                      : surfaceContainerColor,
            ),
            child:
                avatarUrl != null
                    ? ClipOval(
                      child:
                          (!AppConstants.isTesting)
                              ? Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Icon(
                                      isFarmer ? Icons.person : Icons.science,
                                      color: primaryColor,
                                      size: 24,
                                    ),
                              )
                              : Icon(
                                isFarmer ? Icons.person : Icons.science,
                                color: primaryColor,
                                size: 24,
                              ),
                    )
                    : Icon(
                      isFarmer ? Icons.person : Icons.science,
                      color: primaryColor,
                      size: 24,
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          caption,
                          style: GoogleFonts.plusJakartaSans(
                            color: primaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        color: onSurfaceVariantColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariantColor,
                    fontSize: 13,
                    height: 1.4,
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

// Background particle widget
class _GovtParticleBackground extends StatefulWidget {
  const _GovtParticleBackground();

  @override
  State<_GovtParticleBackground> createState() =>
      _GovtParticleBackgroundState();
}

class _GovtParticleBackgroundState extends State<_GovtParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ParticleInfo> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 35; i++) {
      _particles.add(_ParticleInfo(_random));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(() {
      for (var p in _particles) {
        p.update();
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
      painter: _GovtParticlePainter(_particles),
      size: Size.infinite,
    );
  }
}

class _ParticleInfo {
  double x, y;
  double speed;
  double radius;
  double alpha;
  math.Random random;

  _ParticleInfo(this.random)
    : x = random.nextDouble(),
      y = random.nextDouble(),
      speed = 0.0003 + random.nextDouble() * 0.001,
      radius = 0.8 + random.nextDouble() * 2.2,
      alpha = 0.05 + random.nextDouble() * 0.25;

  void update() {
    y -= speed;
    if (y < 0) {
      y = 1.1;
      x = random.nextDouble();
    }
  }
}

class _GovtParticlePainter extends CustomPainter {
  final List<_ParticleInfo> particles;

  _GovtParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var p in particles) {
      paint.color = const Color(0xFF2CC04B).withValues(alpha: p.alpha);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
