import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------
// OPTIONAL standalone preview entrypoint.
// If you're dropping this file into an existing project, just import
// `BuyerDashboardScreen` from your own main.dart and delete `main()`
// and `KrishinetPreviewApp` below — they're only here so this file can
// run on its own while you're testing it.
// -----------------------------------------------------------------------
void main() {
  runApp(const KrishinetPreviewApp());
}

class KrishinetPreviewApp extends StatelessWidget {
  const KrishinetPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishinet Buyer Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
        ),
      ),
      home: const BuyerDashboardScreen(),
    );
  }
}

// --- COLOR PALETTE TOKENS ---
class AppColors {
  static const Color background = Color(0xFF051424);
  static const Color surface = Color(0xFF051424);
  static const Color surfaceContainerLow = Color(0xFF0D1C2D);
  static const Color surfaceContainer = Color(0xFF122131);
  static const Color surfaceContainerHigh = Color(0xFF1C2B3C);
  static const Color surfaceContainerHighest = Color(0xFF273647);
  static const Color primary = Color(0xFF54E167);
  static const Color primaryContainer = Color(0xFF2CC04B);
  static const Color onPrimary = Color(0xFF00390E);
  static const Color onSurface = Color(0xFFD4E4FA);
  static const Color onSurfaceVariant = Color(0xFFBCCBB7);
  static const Color outline = Color(0xFF879583);
  static const Color error = Color(0xFFFFB4AB);
}

// -----------------------------------------------------------------------
// SAFE IMAGE — replaces every raw AssetImage/DecorationImage usage.
// If the asset is missing this shows a soft placeholder instead of
// crashing / breaking the layout, which was the most likely cause of
// "Market / Orders / Profile not working properly".
// -----------------------------------------------------------------------
class SafeAsset extends StatelessWidget {
  final String path;
  final BoxFit fit;
  const SafeAsset(this.path, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder:
          (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.surfaceContainerHigh,
                  AppColors.surfaceContainerLow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.image_outlined,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
              size: 28,
            ),
          ),
    );
  }
}

// --- MAIN DASHBOARD SCREEN ---
class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  int _selectedIndex = 0;

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
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
              const Text(
                "Notifications",
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              _buildNotificationItem(
                "Price Alert!",
                "Wheat prices went up +2.4% today.",
                Icons.trending_up,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                "Order Confirmed",
                "Your payment for Order KN-8841 was verified.",
                Icons.check_circle,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String desc, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quick Search Market",
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter crop name, location...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 1; // Switch to Market tab
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Search"),
              ),
            ],
          ),
        );
      },
    );
  }

  static const List<String> _tabTitles = [
    'HOME',
    'MARKET',
    'ORDERS',
    'PROFILE',
  ];

  Widget _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildMarketPage();
      case 2:
        return _buildOrdersPage();
      case 3:
      default:
        return _buildProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Single shared animated background instead of one per tab —
          // fixes the perf/jank issue from four particle canvases
          // running at once.
          const Positioned.fill(child: ParticleBackground()),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder:
                  (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.03),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
              child: KeyedSubtree(
                key: ValueKey<int>(_selectedIndex),
                child: _currentPage(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 ? _buildAiFab(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // =========================================================================
  // HOME TAB
  // =========================================================================
  Widget _buildHomeTab() {
    return Column(
      children: [
        _buildTopAppBar(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEnterpriseProfile(),
                const SizedBox(height: 20),
                _buildPromoBanner(),
                const SizedBox(height: 24),
                _buildMarketPulse(),
                const SizedBox(height: 24),
                _buildMarketplaceExplorer(),
                const SizedBox(height: 24),
                _buildActiveSupplyChain(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- TOP APP BAR ---
  Widget _buildTopAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Krishinet',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  _buildIconButton(Icons.notifications_none_rounded),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.search_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (icon == Icons.notifications_none_rounded) {
            _showNotificationsSheet();
          } else if (icon == Icons.search_rounded) {
            _showSearchSheet();
          }
        },
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        ),
      ),
    );
  }

  // --- ENTERPRISE PROFILE SECTION ---
  Widget _buildEnterpriseProfile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: AppColors.primary),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: const SafeAsset('images/avatar.jpg'),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.verified,
                                size: 14,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AgroCorp International',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.domain,
                                  size: 16,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Premium Enterprise Buyer',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                                'TIER 1 VENDOR',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Active Bids',
                          '12',
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Fulfilled',
                          '4.2k',
                          suffix: ' t',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Credit', 'AA+')),
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

  Widget _buildStatCard(
    String label,
    String value, {
    String? suffix,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? AppColors.primary : AppColors.onSurface,
                ),
                children: [
                  if (suffix != null)
                    TextSpan(
                      text: suffix,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: AppColors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MARKET PULSE SECTION ---
  Widget _buildMarketPulse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              'Market Pulse',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              'LIVE • 09:41 AM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 115,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildPulseCard(
                'Wheat (Durum)',
                '৳2,450',
                '+2.4%',
                true,
                AppColors.primary,
              ),
              _buildPulseCard(
                'Yellow Corn',
                '৳1,820',
                '-0.8%',
                false,
                AppColors.error,
              ),
              _buildPulseCard(
                'Basmati Rice',
                '৳3,100',
                '+1.2%',
                true,
                AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPulseCard(
    String title,
    String price,
    String change,
    bool isUp,
    Color borderColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(height: 2, color: borderColor),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUp ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        isUp ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: borderColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        change,
                        style: TextStyle(
                          fontSize: 11,
                          color: borderColor,
                          fontWeight: FontWeight.bold,
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

  // --- MARKETPLACE EXPLORER (home preview row) ---
  Widget _buildMarketplaceExplorer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Marketplace Explorer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedIndex = 1),
              child: const Text(
                'SEE ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildMarketItemCard(
                'Premium Durum',
                'Punjab • 500t',
                '৳2,450',
                'Organic',
                AppColors.primary,
                AppColors.onPrimary,
                'images/crop1.jpg',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMarketItemCard(
                'Sweet Yellow Corn',
                'Maha • 120t',
                '৳1,820',
                'Top Seller',
                AppColors.surfaceContainerHighest,
                AppColors.onSurface,
                'images/crop2.jpg',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketItemCard(
    String title,
    String location,
    String price,
    String badgeText,
    Color badgeBg,
    Color badgeFg,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: SafeAsset(imageUrl),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.surfaceContainer.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText.toUpperCase(),
                    style: TextStyle(
                      color: badgeFg,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: price,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          children: const [
                            TextSpan(
                              text: '/q',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Material(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {},
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.onPrimary,
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
    );
  }

  // --- ACTIVE SUPPLY CHAIN ---
  Widget _buildActiveSupplyChain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Supply Chain',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          'KN-8923: 50t Wheat',
          'In Transit • ETA 2 Days',
          Icons.local_shipping,
          true,
          'TRACK',
        ),
        const SizedBox(height: 12),
        _buildOrderCard(
          'KN-8841: 20t Corn',
          'Processing at Hub',
          Icons.inventory_2,
          false,
          'DETAILS',
        ),
      ],
    );
  }

  Widget _buildOrderCard(
    String title,
    String subtitle,
    IconData icon,
    bool isPulse,
    String btnText,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                color:
                    isPulse
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          isPulse
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color:
                          isPulse
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (isPulse) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Flexible(
                              child: Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Showing details/tracking for $title",
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Text(
                          btnText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PROMO BANNER ---
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 175,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const SafeAsset('images/crop3.jpg'),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SEASONAL OFFER',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kharif Season\nProcurement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lock in prices before the rush',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Explore Offers',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MARKET PAGE
  // =========================================================================
  Widget _buildMarketPage() {
    final items = [
      {
        'name': 'Premium Durum Wheat',
        'location': 'Punjab • 500t',
        'price': '৳2,450',
        'badge': 'ORGANIC',
        'img': 'images/crop1.jpg',
      },
      {
        'name': 'Basmati Rice',
        'location': 'Haryana • 200t',
        'price': '৳3,100',
        'badge': 'PREMIUM',
        'img': 'images/crop2.jpg',
      },
      {
        'name': 'Mustard Seeds',
        'location': 'Rajasthan • 80t',
        'price': '৳5,200',
        'badge': 'CERTIFIED',
        'img': 'images/crop3.jpg',
      },
      {
        'name': 'Yellow Maize',
        'location': 'MP • 300t',
        'price': '৳1,820',
        'badge': 'TOP SELLER',
        // Reuses an existing asset instead of pointing at a crop4.jpg
        // that was never declared — this was likely crashing the tab.
        'img': 'images/crop1.jpg',
      },
    ];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Marketplace',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Icon(Icons.tune, color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 110, child: SafeAsset(item['img']!)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['badge']!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['name']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      item['location']!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['price']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Material(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {},
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        child: Text(
                                          'BID',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // ORDERS PAGE
  // =========================================================================
  Widget _buildOrdersPage() {
    final orders = [
      {
        'id': 'KN-8923',
        'item': '50t Premium Wheat',
        'status': 'In Transit',
        'eta': 'ETA: 2 Days',
        'color': 0xFF54E167,
        'icon': Icons.local_shipping,
      },
      {
        'id': 'KN-8841',
        'item': '20t Yellow Corn',
        'status': 'Processing at Hub',
        'eta': 'ETA: 5 Days',
        'color': 0xFFBCCBB7,
        'icon': Icons.inventory_2,
      },
      {
        'id': 'KN-8790',
        'item': '100t Basmati Rice',
        'status': 'Order Confirmed',
        'eta': 'ETA: 7 Days',
        'color': 0xFF54E167,
        'icon': Icons.check_circle_outline,
      },
      {
        'id': 'KN-8701',
        'item': '30t Mustard Seeds',
        'status': 'Delivered',
        'eta': 'Completed',
        'color': 0xFF2CC04B,
        'icon': Icons.done_all,
      },
    ];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '4 Active',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final o = orders[index];
              final col = Color(o['color'] as int);
              final icon = o['icon'] as IconData;
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(width: 4, color: col),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: col.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: col),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${o['id']}: ${o['item']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    o['status'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: col,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    o['eta'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Material(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'TRACK',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // PROFILE PAGE
  // =========================================================================
  Widget _buildProfilePage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.9),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                Icon(
                  Icons.settings_outlined,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: const SafeAsset('images/avatar.jpg'),
          ),
          const SizedBox(height: 16),
          const Text(
            'AgroCorp International',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Premium Enterprise Buyer',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'TIER 1 VENDOR',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildProfileTile(
                  Icons.business_center_outlined,
                  'Business Details',
                  'AgroCorp Intl · GSTIN: 22AAAAA0000A1Z5',
                ),
                _buildProfileTile(
                  Icons.verified_outlined,
                  'KYC Status',
                  'Fully Verified · Tier 1',
                ),
                _buildProfileTile(
                  Icons.receipt_long_outlined,
                  'Transaction History',
                  'View all past orders & invoices',
                ),
                _buildProfileTile(
                  Icons.support_agent_outlined,
                  'Support',
                  'Contact our procurement team',
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
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
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- FLOATING AI FAB ---
  Widget _buildAiFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showAiChatBottomSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.psychology, size: 32),
      ),
    );
  }

  // --- BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabTitles.length, (index) {
                final icons = [
                  Icons.home_filled,
                  Icons.shopping_basket_outlined,
                  Icons.inventory_2_outlined,
                  Icons.person_outline,
                ];
                final selected = _selectedIndex == index;
                return _NavItem(
                  icon: icons[index],
                  label: _tabTitles[index],
                  selected: selected,
                  onTap: () => setState(() => _selectedIndex = index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // --- AI CHAT BOTTOM SHEET ---
  void _showAiChatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 40,
                offset: Offset(0, -12),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.psychology,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Krishi-AI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Online & Processing',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white10),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildAiBubble(
                      'Greetings from AgroCorp Hub. I\'ve analyzed the market for Premium Durum Wheat. Prices in Punjab are expected to stabilize after 48 hours. Should I set an automated bid alert for your target price of ৳2,420?',
                      '09:42 AM',
                    ),
                    const SizedBox(height: 16),
                    _buildUserBubble(
                      'Yes, please set the alert. Also, check availability for corn in Maharashtra for the next quarter.',
                      '09:43 AM',
                    ),
                    const SizedBox(height: 16),
                    _buildAiBubble(
                      'Alert set. Scanning Maharashtra corn inventories... I see 1,200 tons projected for next quarter. 3 verified sellers are already taking pre-orders. Would you like a price comparison table?',
                      '09:43 AM',
                      hasChips: true,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                  border: const Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask Krishi-AI anything...',
                          hintStyle: TextStyle(
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.onPrimary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAiBubble(String text, String time, {bool hasChips = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.psychology,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                if (hasChips) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        label: const Text(
                          'Show Comparison',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text(
                          'Later',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        backgroundColor: AppColors.surfaceContainerHighest,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
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

  Widget _buildUserBubble(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person, size: 18, color: AppColors.onPrimary),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------
// Animated bottom nav item — gives a small scale + color pop on tap
// instead of the plain Material BottomNavigationBar, and is what makes
// switching tabs feel "alive".
// -----------------------------------------------------------------------
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// ANIMATED PARTICLE BACKGROUND — now instantiated once for the whole
// screen instead of once per tab.
// -----------------------------------------------------------------------
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 40; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 1,
          speedX: (_random.nextDouble() * 0.002 - 0.001),
          speedY: (_random.nextDouble() * -0.002 - 0.0005),
          opacity: _random.nextDouble() * 0.4 + 0.2,
        ),
      );
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ParticlePainter(_particles),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class Particle {
  double x, y, size, speedX, speedY, opacity;
  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var p in particles) {
      p.x += p.speedX;
      p.y += p.speedY;
      if (p.y < 0) p.y = 1.0;
      if (p.x < 0) p.x = 1.0;
      if (p.x > 1.0) p.x = 0.0;

      paint.color = AppColors.primary.withValues(alpha: p.opacity);
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
