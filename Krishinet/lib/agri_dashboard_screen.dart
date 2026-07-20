import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/utils/constants.dart';
import 'expert_profile_screen.dart';
import 'expert_chat_screen.dart';
import 'govt_portal_screen.dart';

void main() {
  runApp(const KrishinetApp());
}

class KrishinetApp extends StatelessWidget {
  const KrishinetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishinet | Agri-Expert Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily:
            'Roboto', // Replace with 'Plus Jakarta Sans' if added to pubspec.yaml
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.background,
          onSurface: AppColors.onBackground,
          error: AppColors.error,
        ),
      ),
      home: const KrishinetDashboard(),
    );
  }
}

// ==========================================
// 1. EXACT COLOR PALETTE
// ==========================================
class AppColors {
  static const Color background = Color(0xFF051424);
  static const Color surfaceContainer = Color(0xFF122131);
  static const Color surfaceContainerHigh = Color(0xFF1C2B3C);
  static const Color surfaceContainerLow = Color(0xFF0D1C2D);
  static const Color surfaceContainerHighest = Color(0xFF273647);
  static const Color primary = Color(0xFF54E167);
  static const Color primaryContainer = Color(0xFF2CC04B);
  static const Color onBackground = Color(0xFFD4E4FA);
  static const Color onSurfaceVariant = Color(0xFFBCCBB7);
  static const Color error = Color(0xFFFFB4AB);
  static const Color tertiary = Color(0xFFC5C7C6);
  static const Color tertiaryContainer = Color(0xFFA6A8A8);
  static const Color outlineVariant = Color(0xFF3D4A3B);
  static const Color secondary = Color(0xFFC6C6C6);

  // Glassmorphism exact values: rgba(18, 33, 49, 0.7) and border rgba(255, 255, 255, 0.05)
  static const Color glassBackground = Color(0xB3122131);
  static const Color glassBorder = Color(0x0DFFFFFF);
}

// ==========================================
// 2. MAIN DASHBOARD SCREEN
// ==========================================
class KrishinetDashboard extends StatefulWidget {
  const KrishinetDashboard({super.key});

  @override
  State<KrishinetDashboard> createState() => _KrishinetDashboardState();
}

class _KrishinetDashboardState extends State<KrishinetDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Growth Particles Effect
          const Positioned.fill(child: ParticleBackground()),

          // Main Scrollable Content
          SafeArea(bottom: false, child: _buildBody()),

          // Floating Glass Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sticky Glass Header
            SliverToBoxAdapter(
              child: HeaderSection(
                onProfileTap: () => setState(() => _selectedIndex = 3),
              ),
            ),

            // Content Body
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const ImpactAnalyticsSection(),
                  const SizedBox(height: 32),
                  UpcomingAppointmentsSection(
                    onAppointmentTap: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(height: 32),
                  ActiveChatsSection(
                    onChatTap: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(height: 32),
                  OfficerPortalSection(
                    onContactTap: () => setState(() => _selectedIndex = 2),
                  ),
                  const SizedBox(height: 32),
                  const KnowledgeBaseSection(),
                  const SizedBox(height: 120), // Extra space for Bottom Nav
                ]),
              ),
            ),
          ],
        );
      case 1:
        return const ExpertChatScreen(isEmbedded: true);
      case 2:
        return const GovtPortalScreen(isEmbedded: true);
      case 3:
        return const ExpertProfileScreen(isEmbedded: true);
      default:
        return const SizedBox();
    }
  }
}

// ==========================================
// 3. REUSABLE GLASS CARD WIDGET
// ==========================================
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Border? customBorder;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
    this.customBorder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: child,
    );

    // Render non-uniform borders via overlay stripe to avoid Flutter paint crash
    // when borderRadius is combined with non-uniform borders
    if (customBorder != null && customBorder!.left.width > 0) {
      mainContent = Stack(
        children: [
          mainContent,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: customBorder!.left.width,
              decoration: BoxDecoration(
                color: customBorder!.left.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: mainContent,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

// ==========================================
// 4. HEADER SECTION
// ==========================================
class HeaderSection extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const HeaderSection({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=150&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Dr. Aman Singh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
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
}

// ==========================================
// 5. IMPACT ANALYTICS SECTION
// ==========================================
class ImpactAnalyticsSection extends StatelessWidget {
  const ImpactAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COMPLETED',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '1,284',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+12%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Total Consultations',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            customBorder: const Border(
              left: BorderSide(color: AppColors.primary, width: 4),
              top: BorderSide(color: AppColors.glassBorder),
              right: BorderSide(color: AppColors.glassBorder),
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'IMPACT SCORE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '98.4',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.star, color: AppColors.primary, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Top Tier Expert',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 6. UPCOMING APPOINTMENTS SECTION
// ==========================================
class UpcomingAppointmentsSection extends StatelessWidget {
  final VoidCallback? onAppointmentTap;
  const UpcomingAppointmentsSection({super.key, this.onAppointmentTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAppointmentCard(
          icon: Icons.agriculture,
          iconBgColor: AppColors.primaryContainer.withValues(alpha: 0.2),
          iconColor: AppColors.primary,
          title: 'Soil Health Review',
          subtitle: 'Farmer: Rajesh Kumar • 10:00 AM',
          onTap: onAppointmentTap,
        ),
        const SizedBox(height: 12),
        _buildAppointmentCard(
          icon: Icons.pest_control,
          iconBgColor: AppColors.primaryContainer.withValues(alpha: 0.1),
          iconColor: AppColors.primary.withValues(alpha: 0.8),
          title: 'Pest Outbreak Analysis',
          subtitle: 'Farmer: Sunita Devi • 01:30 PM',
          onTap: onAppointmentTap,
        ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

// ==========================================
// 7. ACTIVE CHATS SECTION
// ==========================================
class ActiveChatsSection extends StatelessWidget {
  final VoidCallback? onChatTap;
  const ActiveChatsSection({super.key, this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Active Chats",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '3 URGENT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004713),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            children: [
              _buildChatItem(
                name: 'Amit Singh',
                status: 'Typing...',
                imageUrl:
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
                statusColor: AppColors.primary,
                isUrgent: true,
                isPulse: true,
                onTap: onChatTap,
              ),
              const SizedBox(width: 16),
              _buildChatItem(
                name: 'Meena Rao',
                status: '2m ago',
                imageUrl:
                    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=150&q=80',
                statusColor: AppColors.secondary,
                onTap: onChatTap,
              ),
              const SizedBox(width: 16),
              _buildChatItem(
                name: 'Vikram J.',
                status: '15m ago',
                imageUrl:
                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
                statusColor: AppColors.primary,
                onTap: onChatTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatItem({
    required String name,
    required String status,
    required String imageUrl,
    required Color statusColor,
    bool isUrgent = false,
    bool isPulse = false,
    VoidCallback? onTap,
  }) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border:
            isUrgent
                ? const Border(
                  top: BorderSide(color: AppColors.primary, width: 2),
                )
                : null,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        isUrgent
                            ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              width: 2,
                            )
                            : null,
                    image: DecorationImage(
                      image: AppConstants.buildImageProvider(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surfaceContainer,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isPulse ? FontWeight.bold : FontWeight.normal,
                color: isPulse ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 8. GOVERNMENT LIAISON (OFFICER PORTAL)
// ==========================================
class OfficerPortalSection extends StatelessWidget {
  final VoidCallback? onContactTap;
  const OfficerPortalSection({super.key, this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerHigh,
            AppColors.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Glowing orb background
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Officer Portal',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Direct communication channel with Department of Agriculture officers for subsidy approvals and policy clarifications.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onContactTap,
                          icon: const Icon(Icons.contact_mail, size: 18),
                          label: const Text(
                            'Contact Officer',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: const Color(0xFF00390E),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.description, size: 18),
                          label: const Text(
                            'View Directives',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onBackground,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
    );
  }
}

// ==========================================
// 9. KNOWLEDGE BASE SECTION
// ==========================================
class KnowledgeBaseSection extends StatelessWidget {
  const KnowledgeBaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Knowledge Base",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Manage Feed',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Article Card 1
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 176,
                    width: double.infinity,
                    child: AppConstants.buildNetworkImage(
                      context: context,
                      url:
                          'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=800&q=80',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: AppColors.surfaceContainer,
                            child: const Center(
                              child: Icon(
                                Icons.park,
                                color: AppColors.primary,
                                size: 48,
                              ),
                            ),
                          ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.surfaceContainer,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'FEATURED POST',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Text(
                          'Oct 24, 2023',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Maximizing Rabi Yields through Regenerative Practices',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Recent analytics suggest that local nitrogen levels are dipping across North zones. Recommend adding clover cover crops to maintain soil health for the upcoming cycle.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Edit Post',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    AppColors.surfaceContainerHighest,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.share,
                                size: 18,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '1.2k',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Article Card 2 (Suggestion)
        GlassCard(
          padding: const EdgeInsets.all(20),
          customBorder: const Border(
            left: BorderSide(color: AppColors.tertiaryContainer, width: 4),
            top: BorderSide(color: AppColors.glassBorder),
            right: BorderSide(color: AppColors.glassBorder),
            bottom: BorderSide(color: AppColors.glassBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EXPERT SUGGESTION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tertiary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '2h ago',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Intercropping Mustard with Wheat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Data from the Punjab region shows a 15% reduction in pest outbreaks when intercropping is implemented...',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            'Read Full Memo',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.north_east,
                            color: AppColors.primary,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 10. BOTTOM NAVIGATION BAR
// ==========================================
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 24,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 32,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.calendar_month, 'SCHEDULE'),
              _buildNavItem(1, Icons.chat_bubble_outline, 'CHAT'),
              _buildNavItem(2, Icons.account_balance_outlined, 'GOV PORTAL'),
              _buildNavItem(3, Icons.person_outline, 'PROFILE'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color:
                  isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color:
                  isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 11. THREE.JS PARTICLE GROWTH BACKGROUND
// ==========================================
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int _particleCount = 40;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Initialize Particles
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 0.5,
          speedX: _random.nextDouble() * 0.002 - 0.001,
          speedY:
              _random.nextDouble() * -0.002 - 0.0005, // Upward floating drift
          opacity: _random.nextDouble() * 0.5 + 0.2,
        ),
      );
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() {
            for (var p in _particles) {
              p.x += p.speedX;
              p.y += p.speedY;

              if (p.y < 0) p.y = 1.0;
              if (p.x < 0) p.x = 1.0;
              if (p.x > 1) p.x = 0.0;
            }
            setState(() {});
          })
          ..repeat();
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
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint =
          Paint()
            ..color = AppColors.primary.withValues(alpha: p.opacity)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
