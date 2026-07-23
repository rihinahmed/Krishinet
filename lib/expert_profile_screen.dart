import 'dart:ui';
import 'package:flutter/material.dart';
import 'expert_login_screen.dart';

class ExpertProfileScreenPalette {
  // Utility values matching the palette
}

class ExpertProfileScreen extends StatefulWidget {
  final bool isEmbedded;
  const ExpertProfileScreen({super.key, this.isEmbedded = false});

  @override
  State<ExpertProfileScreen> createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends State<ExpertProfileScreen> {
  // Theme Colors
  final Color background = const Color(0xFF051424);
  final Color surfaceContainer = const Color(0xFF122131);
  final Color surfaceContainerHigh = const Color(0xFF1C2B3C);
  final Color surfaceContainerHighest = const Color(0xFF273647);
  final Color primary = const Color(0xFF54E167);
  final Color onBackground = const Color(0xFFD4E4FA);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color error = const Color(0xFFFFB4AB);
  final Color glassBackground = const Color(0xB3122131);
  final Color glassBorder = const Color(0x0DFFFFFF);

  // Profile status toggles
  bool _isAvailableForConsult = true;
  bool _pushNotifications = true;
  bool _dndMode = false;
  bool _biometricLock = true;

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Profile Profile Header card
          _buildProfileMainCard(),
          const SizedBox(height: 24),

          // 2. Statistics Grid
          _buildStatsGrid(),
          const SizedBox(height: 24),

          // 3. Credentials and Specializations
          _buildSpecializationsCard(),
          const SizedBox(height: 24),

          // 4. Interactive Configuration Settings Toggles
          _buildSettingsGroup(),
          const SizedBox(height: 24),

          // 5. Destructive Log Out Action
          _buildLogOutButton(),
          const SizedBox(height: 120), // Extra space for floating Bottom Nav
        ],
      ),
    );

    if (widget.isEmbedded) {
      return Column(
        children: [_buildHeaderBar(context), Expanded(child: content)],
      );
    }

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [_buildHeaderBar(context), Expanded(child: content)],
        ),
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!widget.isEmbedded)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              Text(
                'Expert Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: onBackground,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: primary, size: 14),
                const SizedBox(width: 4),
                Text(
                  'VERIFIED EXPERT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMainCard() {
    return _buildGlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary, width: 2.5),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&w=250&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                    border: Border.all(color: glassBorder),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Dr. Safwan Rahman',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: onBackground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PhD, Soil Science & Plant Entomology',
            style: TextStyle(fontSize: 14, color: onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: primary, size: 16),
              const SizedBox(width: 4),
              Text(
                'Dhaka Regional Hub, Bangladesh',
                style: TextStyle(fontSize: 12, color: onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildGlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(Icons.forum_outlined, color: primary, size: 24),
                const SizedBox(height: 8),
                const Text(
                  '1.2k+',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Consultations',
                  style: TextStyle(color: onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(Icons.star, color: primary, size: 24),
                const SizedBox(height: 8),
                const Text(
                  '4.9',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'User Rating',
                  style: TextStyle(color: onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(Icons.verified_user_outlined, color: primary, size: 24),
                const SizedBox(height: 8),
                const Text(
                  '10 Years',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Experience',
                  style: TextStyle(color: onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecializationsCard() {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium, color: primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Specializations & Special Credentials',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBadgeItem('Soil Chemistry & Mineral Analysis'),
          _buildBadgeItem('Pest Control and Pathology Mitigation'),
          _buildBadgeItem('Hydroponic and Aeroponic Design'),
          _buildBadgeItem('Govt Subsidy Eligibility Verification'),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.5, color: onBackground),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup() {
    return _buildGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Configuration & Controls',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildToggleOption(
            icon: Icons.chat_bubble_outline,
            title: 'Available for Farming Queries',
            subtitle: 'Toggle visibility in farmer search lists.',
            value: _isAvailableForConsult,
            onChanged: (val) => setState(() => _isAvailableForConsult = val),
          ),
          const Divider(color: Colors.white10),
          _buildToggleOption(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            subtitle: 'Sound & vibration for farmer queries.',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          const Divider(color: Colors.white10),
          _buildToggleOption(
            icon: Icons.do_not_disturb_on_outlined,
            title: 'Do Not Disturb',
            subtitle: 'Silence alerts outside schedule hours.',
            value: _dndMode,
            onChanged: (val) => setState(() => _dndMode = val),
          ),
          const Divider(color: Colors.white10),
          _buildToggleOption(
            icon: Icons.fingerprint,
            title: 'Biometric FaceID Lock',
            subtitle: 'Secure consultant account login.',
            value: _biometricLock,
            onChanged: (val) => setState(() => _biometricLock = val),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: onSurfaceVariant),
                ),
              ],
            ),
          ),
          Switch(value: value, activeThumbColor: primary, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildLogOutButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Log out workflow: push offset back to login screen and clear stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ExpertLoginScreen()),
          (route) => false,
        );
      },
      icon: const Icon(Icons.logout, size: 18),
      label: const Text(
        'Sign Out / Log Out',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: error.withValues(alpha: 0.1),
        foregroundColor: error,
        side: BorderSide(color: error.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: glassBorder, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
