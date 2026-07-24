import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/utils/constants.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Brand colors matching the design system
  final Color baseBackground = const Color(0xFF051424);
  final Color baseCardBackground = const Color(0xFF122131);

  // Helper to safely load network images without throwing HTTP 400 exceptions during widget testing
  Widget _buildNetworkImage(
    String url, {
    required BoxFit fit,
    required Widget Function(BuildContext, Object, StackTrace?) errorBuilder,
  }) {
    if (AppConstants.isTesting) {
      return errorBuilder(context, Exception('Testing env placeholder'), null);
    }
    return Image.network(url, fit: fit, errorBuilder: errorBuilder);
  }

  final Color surfaceContainerHigh = const Color(0xFF1C2B3C);
  final Color primaryColor = const Color(0xFF54E167);
  final Color primaryContainerColor = const Color(0xFF2CC04B);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);

  int _selectedTab =
      0; // 0: Global Analytics, 1: User Management, 2: Expert Network, 3: System Health, 4: Settings
  String _timeRange = '1W'; // '1W', '1M', '1Y'

  // Mock list of nodes for system health
  final List<Map<String, String>> _nodes = [
    {
      'name': 'Node Agri-Delta (Main)',
      'zone': 'Asia-South East',
      'latency': '12ms',
      'status': 'Optimal',
    },
    {
      'name': 'Node Expert-Sync',
      'zone': 'Asia-South East',
      'latency': '24ms',
      'status': 'Optimal',
    },
    {
      'name': 'Node Market-Core',
      'zone': 'Asia-West',
      'latency': '45ms',
      'status': 'Optimal',
    },
    {
      'name': 'Node Sensor-IoT',
      'zone': 'Asia-North',
      'latency': '88ms',
      'status': 'Optimal',
    },
    {
      'name': 'Node Backup-Mirror',
      'zone': 'Europe-Central',
      'latency': '164ms',
      'status': 'Optimal',
    },
  ];

  // Mock user list
  final List<Map<String, String>> _users = [
    {
      'name': 'Dr. Arnab Sen',
      'role': 'Agri-Expert',
      'email': 'arnab.sen@krishinet.org',
      'status': 'Active',
    },
    {
      'name': 'Ramesh Mandal',
      'role': 'Farmer',
      'email': 'ramesh.m@farm.net',
      'status': 'Active',
    },
    {
      'name': 'Buyer Syndicate Corp',
      'role': 'Merchant/Buyer',
      'email': 'trade@syndicate.com',
      'status': 'Flagged',
    },
    {
      'name': 'Tahmid Rahman',
      'role': 'Agri-Expert',
      'email': 'tahmid@expert.krishinet.org',
      'status': 'Pending',
    },
  ];

  // Handle Action Trigger feedback
  void _executeQuickAction(String actionName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              'Successfully Executed: $actionName',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 1024;

    return Scaffold(
      backgroundColor: baseBackground,
      body: Row(
        children: [
          // Sidebar drawer navigation panel (Only shown on large viewports)
          if (isLargeScreen) _buildSidebarDrawer(),

          Expanded(
            child: SafeArea(
              bottom: !isLargeScreen,
              child: Column(
                children: [
                  _buildHeaderBar(isLargeScreen),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [_buildSelectedViewport()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLargeScreen ? null : _buildMobileBottomBar(),
    );
  }

  // Switch between page displays
  Widget _buildSelectedViewport() {
    switch (_selectedTab) {
      case 0:
        return _buildGlobalAnalyticsView();
      case 1:
        return _buildUserManagementView();
      case 2:
        return _buildExpertNetworkView();
      case 3:
        return _buildSystemHealthView();
      case 4:
        return _buildAdminSettingsView();
      default:
        return _buildGlobalAnalyticsView();
    }
  }

  // ---------------- PAGE VIEWS ----------------

  // View 0: Global Analytics (Core Dashboard)
  Widget _buildGlobalAnalyticsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsBentoRow(),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _buildRevenueTrendsWidget()),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: _buildSideInfoWidgetsPanel()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildRevenueTrendsWidget(),
                  const SizedBox(height: 20),
                  _buildSideInfoWidgetsPanel(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  // View 1: User Management Panel
  Widget _buildUserManagementView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader('User Access Management', Icons.group),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System Accounts',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton.icon(
                    onPressed:
                        () => _executeQuickAction('Sync Accounts Database'),
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text('Refresh'),
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
                ],
              ),
              const Divider(color: Colors.white10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _users.length,
                separatorBuilder:
                    (context, index) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final isFlagged = user['status'] == 'Flagged';
                  final isPending = user['status'] == 'Pending';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    isFlagged
                                        ? Colors.red.withValues(alpha: 0.1)
                                        : (isPending
                                            ? Colors.yellow.withValues(
                                              alpha: 0.1,
                                            )
                                            : primaryColor.withValues(
                                              alpha: 0.1,
                                            )),
                                child: Icon(
                                  user['role'] == 'Agri-Expert'
                                      ? Icons.science
                                      : Icons.person,
                                  color:
                                      isFlagged
                                          ? Colors.red
                                          : (isPending
                                              ? Colors.yellow[600]
                                              : primaryColor),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user['name']!,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            user['role']!,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: onSurfaceVariant,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      user['email']!,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: onSurfaceVariant,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              user['status']!,
                              style: GoogleFonts.plusJakartaSans(
                                color:
                                    isFlagged
                                        ? Colors.red
                                        : (isPending
                                            ? Colors.yellow[600]
                                            : primaryColor),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // View 2: Expert Network Review
  Widget _buildExpertNetworkView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader('Agri-Expert Verification Enclave', Icons.psychology),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Expert Onboarding Requests',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Verify credentials, research records, and regional licensing documents of applicants.',
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              _buildReviewPanelItem(
                name: 'Dr. Arnab Sen',
                deg: 'Soil Science Specialist • Ph.D. IARI',
                institute: 'National Crop Research Center',
                details:
                    'Licensing board check: Cleared. Background verification check: Enrolled.',
              ),
              const Divider(color: Colors.white10),
              _buildReviewPanelItem(
                name: 'Sarah Mitchell',
                deg: 'Entomologist • Pesticide Toxicologist',
                institute: 'Agricultural Pathology Institute',
                details:
                    'Bio-security clearance: Complete. Active reviews: None.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewPanelItem({
    required String name,
    required String deg,
    required String institute,
    required String details,
  }) {
    return Column(
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  deg,
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  institute,
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed:
                      () => _executeQuickAction('Apprived $name credentials'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: const Color(0xFF00390E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _executeQuickAction('Escalated $name check'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Escalate', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            details,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // View 3: System Health Enclave
  Widget _buildSystemHealthView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader('Network System Nodes', Icons.monitor_heart),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Computational Node Clustering',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(color: Colors.white10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _nodes.length,
                separatorBuilder:
                    (context, index) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
                  final node = _nodes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node['name']!,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Geographical Enclave: ${node['zone']}',
                              style: GoogleFonts.plusJakartaSans(
                                color: onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Ping: ${node['latency']}',
                              style: GoogleFonts.plusJakartaSans(
                                color: onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                node['status']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // View 4: Admin Settings Control
  Widget _buildAdminSettingsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader('Admin Settings Console', Icons.settings),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security Enclaves',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(color: Colors.white10),
              SwitchListTile(
                value: true,
                onChanged: (val) {},
                title: Text(
                  'Require level-IV administrative keys',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  'Enforces strict security checks on logins.',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                activeThumbColor: primaryColor,
              ),
              SwitchListTile(
                value: false,
                onChanged: (val) {},
                title: Text(
                  'Offline Backup Syncing',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  'Saves local copies when internet is restricted.',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                activeThumbColor: primaryColor,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _executeQuickAction('Flush Cache Terminals'),
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Flush Database Cache'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF93000A),
                  foregroundColor: const Color(0xFFFFDAD6),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageHeader(String title, IconData icon) {
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

  // ---------------- MODULE SUB-COMPONENTS ----------------

  Widget _buildSidebarDrawer() {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: baseCardBackground,
        border: const Border(
          right: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AgriEcosystem Admin',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'ADMINISTRATIVE CONSOLE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSidebarDrawerItem(0, Icons.analytics, 'Global Analytics'),
                const SizedBox(height: 6),
                _buildSidebarDrawerItem(1, Icons.group, 'User Management'),
                const SizedBox(height: 6),
                _buildSidebarDrawerItem(2, Icons.psychology, 'Expert Network'),
                const SizedBox(height: 6),
                _buildSidebarDrawerItem(
                  3,
                  Icons.monitor_heart,
                  'System Health',
                ),
                const SizedBox(height: 6),
                _buildSidebarDrawerItem(4, Icons.settings, 'Admin Settings'),
              ],
            ),
          ),

          // Master Admin identity display card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ClipOval(
                    child: _buildNetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD6ffwJ5RJtWzdLSjFTtIN3tUL97nMPFWxAIc9t3LEmX6fW13iKOgjLBuY-GSVu3wehcHsqBfSuk1VxJc3BM55v3sLRoVLWFSQ0Y5oq_FPPFHQO6y1sKBk-wxzw6LlcOUJhbbMH-P4BoOvrrpiSneE6W2VfGTNrX_UDwxNTVE_fN8JSTCEOjksHOjE8BqzLOiHWsyWzxUtMb5yzTvlUgCHX1u42LcUmvRa1HPtHZYJuyi0Dwy3fkf_M4fplujBvdIYjVpA1KOPeZGke',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.admin_panel_settings,
                            color: primaryColor,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Global Controller',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Text(
                  'V1.2.4',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarDrawerItem(int index, IconData icon, String label) {
    bool isSelected = _selectedTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryContainerColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00390E) : onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color:
                      isSelected ? const Color(0xFF00390E) : onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar(bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
              if (!isLargeScreen) ...[
                IconButton(
                  icon: Icon(Icons.grid_view, color: primaryColor),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                Text(
                  'AgriEcosystem',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 20,
                  ),
                ),
              ] else ...[
                Text(
                  'Dashboard',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: onSurfaceVariant.withValues(alpha: 0.4),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedTabTitle(),
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),

          Row(
            children: [
              // Server optimal heartbeat node indicator
              if (isLargeScreen) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Server: Optimal',
                        style: GoogleFonts.plusJakartaSans(
                          color: onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],

              // User Info Trigger Avatar
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = 4; // Settings / Profile
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildNetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDwJsmakQEVnA18ds1LJEEVSEQdzk-1WJwzo4U0hYuirXsbIkyjjI0WmQL76uBABQGUdUyvnG1tu-BUtfC2Wts9c0Uq0injt8asRcUittEGVVUBg3Oecni8a6U87uKjQo5fKKBjfj2JxW-bA_59X3uvlDCyvs0-O-m3Wvsywg5bc5ylvn6FmRh8gjTRgi1vxktmjLSmdh0j5roGxTVUSFvyGA9vDNPT4UhoOOa_615x2yOm394poA1ZvnU0nmXgX2A7jRwUABkKn8_Q',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.person, color: primaryColor, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _selectedTabTitle() {
    switch (_selectedTab) {
      case 0:
        return 'Global Overview';
      case 1:
        return 'User Management';
      case 2:
        return 'Expert Reviews';
      case 3:
        return 'System Stability';
      case 4:
        return 'Settings Control';
      default:
        return 'Global Overview';
    }
  }

  // Bento stats grid row representing farmers, experts, volume in Taka, and uptime status
  Widget _buildStatsBentoRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            children: [
              _buildStatsBentoCard(
                'Total Farmers',
                '1.2M',
                '+12.4% this month',
                Icons.agriculture,
              ),
              const SizedBox(height: 12),
              _buildStatsBentoCard(
                'Experts Network',
                '8.5K',
                '98% verification rate',
                Icons.psychology,
              ),
              const SizedBox(height: 12),
              _buildStatsBentoCard(
                'Gross Volume',
                '৳24.8M',
                'All-time high reached',
                Icons.payments,
              ),
              const SizedBox(height: 12),
              _buildStatsBentoCard(
                'Uptime Score',
                '99.98%',
                '5 Nodes active',
                Icons.memory,
              ),
            ],
          );
        } else if (constraints.maxWidth < 1100) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatsBentoCard(
                'Total Farmers',
                '1.2M',
                '+12.4% this month',
                Icons.agriculture,
              ),
              _buildStatsBentoCard(
                'Experts Network',
                '8.5K',
                '98% verification rate',
                Icons.psychology,
              ),
              _buildStatsBentoCard(
                'Gross Volume',
                '৳24.8M',
                'All-time high reached',
                Icons.payments,
              ),
              _buildStatsBentoCard(
                'Uptime Score',
                '99.98%',
                '5 Nodes active',
                Icons.memory,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: _buildStatsBentoCard(
                  'Total Farmers',
                  '1.2M',
                  '+12.4% this month',
                  Icons.agriculture,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsBentoCard(
                  'Experts Network',
                  '8.5K',
                  '98% verification rate',
                  Icons.psychology,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsBentoCard(
                  'Gross Volume',
                  '৳24.8M',
                  'All-time high reached',
                  Icons.payments,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsBentoCard(
                  'Uptime Score',
                  '99.98%',
                  '5 Nodes active',
                  Icons.memory,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatsBentoCard(
    String title,
    String value,
    String tag,
    IconData icon,
  ) {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              icon,
              size: 56,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.trending_up, color: primaryColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    tag,
                    style: GoogleFonts.plusJakartaSans(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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

  // Visual widget representing trends (revenue bar stats)
  Widget _buildRevenueTrendsWidget() {
    // Height factors representing chart bar spikes
    final List<double> barFactors = [0.45, 0.65, 0.55, 0.85, 0.75, 0.60, 0.90];
    final List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return _buildGlassCard(
      padding: const EdgeInsets.all(24),
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
                    'Revenue & Transaction Trends',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Weekly aggregation across global markets',
                    style: GoogleFonts.plusJakartaSans(
                      color: onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children:
                    ['1W', '1M', '1Y'].map((rangeName) {
                      bool isSelected = _timeRange == rangeName;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _timeRange = rangeName;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? surfaceContainerHigh
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.white10
                                        : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              rangeName,
                              style: GoogleFonts.plusJakartaSans(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // Custom horizontal bar grid chart
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                double relativeHeight = barFactors[index];
                bool isMax = index == 6; // Sun height tag

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FractionallySizedBox(
                            alignment: Alignment.bottomCenter,
                            heightFactor: relativeHeight,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                color:
                                    isMax
                                        ? primaryColor
                                        : primaryColor.withValues(alpha: 0.2),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                boxShadow:
                                    isMax
                                        ? [
                                          BoxShadow(
                                            color: primaryColor.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          days[index],
                          style: GoogleFonts.plusJakartaSans(
                            color: onSurfaceVariant.withValues(alpha: 0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 24),

          // Quick actions grid underneath chart
          _buildQuickActionButtons(),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return Column(
            children: [
              _buildActionBtn(
                'New Expert Onboarding',
                Icons.person_add,
                primaryColor,
                const Color(0xFF00390E),
                true,
              ),
              const SizedBox(height: 10),
              _buildActionBtn(
                'Push System Update',
                Icons.security_update_good,
                Colors.white,
                Colors.white10,
                false,
              ),
              const SizedBox(height: 10),
              _buildActionBtn(
                'Data Backup (Cloud)',
                Icons.storage,
                Colors.white,
                Colors.white10,
                false,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  'New Expert Onboarding',
                  Icons.person_add,
                  primaryColor,
                  const Color(0xFF00390E),
                  true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionBtn(
                  'Push System Update',
                  Icons.security_update_good,
                  Colors.white,
                  Colors.white10,
                  false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionBtn(
                  'Data Backup (Cloud)',
                  Icons.storage,
                  Colors.white,
                  Colors.white10,
                  false,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildActionBtn(
    String label,
    IconData icon,
    Color txtColor,
    Color bgColor,
    bool primary,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _executeQuickAction(label),
      icon: Icon(icon, size: 18, color: txtColor),
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: txtColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? primaryContainerColor : surfaceContainerHigh,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              primary
                  ? BorderSide.none
                  : const BorderSide(color: Colors.white10),
        ),
        elevation: 0,
      ),
    );
  }

  // Sidebar info panel combining activity logging and insights
  Widget _buildSideInfoWidgetsPanel() {
    return Column(
      children: [
        _buildRecentActivityWidget(),
        const SizedBox(height: 20),
        _buildMarketInsightsWidget(),
      ],
    );
  }

  Widget _buildRecentActivityWidget() {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            'New Warehouse Listed',
            'Punjab Regional Center • 2m ago',
            Icons.inventory_2,
            primaryColor,
          ),
          const Divider(color: Colors.white10),
          _buildActivityItem(
            'Flagged User Account',
            'ID: 4492 - Suspicious activity • 15m ago',
            Icons.report,
            Colors.red,
          ),
          const Divider(color: Colors.white10),
          _buildActivityItem(
            'Expert Verified',
            'Dr. Arnab Sen • Soil Science • 1h ago',
            Icons.verified_user,
            primaryColor,
          ),
          const Divider(color: Colors.white10),
          _buildActivityItem(
            'Bulk Transaction Success',
            'Cotton Coop → Buyer X • 3h ago',
            Icons.swap_horiz,
            onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.02),
              foregroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.white10),
              ),
              textStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            child: const Text('VIEW ALL ACTIVITY'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String desc,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsightsWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 192,
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildNetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDT-JBz3ZDb4Gxb3Hbb_b0sPA1qtXH4oU3oBJ0nVnV0UaQlDxsChZr9_FFy6cY5vROgEFQDacFkLm-zvlK2akXQES3YfESsSF4_vdWRAUf8YKvi0r14ymiWHCgTIt7xzwARzqwRyc7Yn2d-zGZddcjhCxT_QxrzJhC1CNdcv0TMwNKoMpglTq_4pvN_Ex4wjStor2qUgrXcHNr6mtIJZ8Ko5VC9CZjNCe3KeqkhINOu8cQ4Q-b8tgmS5xKtp5ugcbuv-JwwFp1-soYj',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: baseCardBackground,
                      child: Icon(
                        Icons.show_chart,
                        color: primaryColor,
                        size: 48,
                      ),
                    ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      baseBackground.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Expansion',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Southeast Asia Corridor - Q4',
                    style: GoogleFonts.plusJakartaSans(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: InkWell(
                onTap: () => _executeQuickAction('Open Market Portal'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.open_in_new,
                    color: Color(0xFF00390E),
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: baseCardBackground.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: child,
        ),
      ),
    );
  }

  // Mobile Bottom navigation layout
  Widget _buildMobileBottomBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        color: baseCardBackground.withValues(alpha: 0.95),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Stats',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'Experts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_heart),
              label: 'Health',
            ),
          ],
        ),
      ),
    );
  }
}
