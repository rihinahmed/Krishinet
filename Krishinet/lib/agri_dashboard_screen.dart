import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'core/utils/constants.dart';
import 'expert_profile_screen.dart';
import 'expert_chat_screen.dart';
import 'govt_portal_screen.dart';
import 'expert_appointments_screen.dart';
import 'widgets/knowledge_base_section.dart';

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
  bool _hasNotifications = true;
  final List<Map<String, String>> _notifications = [
    {
      'title': '🚨 Critical Outbreak Alert',
      'body': 'Lumpy Skin Disease outbreak reported in Ward 2, Sreepur.',
      'time': '10 mins ago',
    },
    {
      'title': '📅 New Appointment Scheduled',
      'body': 'Farmer Kalam Miah booked a consultation for Cow disease.',
      'time': '1 hr ago',
    },
    {
      'title': '💬 Unread Farmer Query',
      'body': 'Abdul Baten asked about Boro Paddy pests.',
      'time': '2 hrs ago',
    },
  ];

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Recent Alerts & Notifications",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  if (_notifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          "All caught up! No new notifications.",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ..._notifications.map((n) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              n['title']!.contains('🚨')
                                  ? Icons.warning_amber
                                  : (n['title']!.contains('📅')
                                      ? Icons.calendar_today
                                      : Icons.chat_bubble_outline),
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n['body']!,
                                    style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n['time']!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 16),
                  if (_notifications.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setModalState(() {
                            _notifications.clear();
                          });
                          setState(() {
                            _hasNotifications = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: const Color(0xFF00390E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Clear All",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                onProfileTap: () => setState(() => _selectedIndex = 4),
                onNotificationTap: _showNotificationsSheet,
                hasNotification: _hasNotifications,
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
                  const ExpertToolkitSection(),
                  const SizedBox(height: 32),
                  UpcomingAppointmentsSection(
                    onAppointmentTap: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(height: 32),
                  const KnowledgeBaseSection(role: 'expert'),
                  const SizedBox(height: 120), // Extra space for Bottom Nav
                ]),
              ),
            ),
          ],
        );
      case 1:
        return const ExpertAppointmentsScreen(isEmbedded: true);
      case 2:
        return const ExpertChatScreen(isEmbedded: true);
      case 3:
        return const GovtPortalScreen(isEmbedded: true);
      case 4:
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
  final VoidCallback? onNotificationTap;
  final bool hasNotification;

  const HeaderSection({
    super.key,
    this.onProfileTap,
    this.onNotificationTap,
    this.hasNotification = true,
  });

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
                        image: DecorationImage(
                          image: AppConstants.buildImageProvider(
                            'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&w=150&q=80',
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
                        'Dr. Safwan Rahman',
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
              GestureDetector(
                onTap: onNotificationTap,
                behavior: HitTestBehavior.opaque,
                child: Stack(
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
                    if (hasNotification)
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
class ExpertToolkitSection extends StatefulWidget {
  const ExpertToolkitSection({super.key});

  @override
  State<ExpertToolkitSection> createState() => _ExpertToolkitSectionState();
}

class _ExpertToolkitSectionState extends State<ExpertToolkitSection> {
  // Form controllers / mock data states

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- 1. Animal Consultation Sheet ---
  final List<Map<String, String>> _registeredFarmers = [
    {'name': 'Karim Miah', 'phone': '01712345678'},
    {'name': 'Rihin Farmer', 'phone': '01812345678'},
    {'name': 'Mitu Khatun', 'phone': '01912345678'},
    {'name': 'Kalam Miah', 'phone': '01511223344'},
    {'name': 'Sufia Begum', 'phone': '01655667788'},
    {'name': 'Jashim Uddin', 'phone': '01799887766'},
    {'name': 'Jalal Ahmed', 'phone': '01833445566'},
  ];

  Future<void> _generatePrescriptionPdf({
    required String farmerName,
    required String farmerPhone,
    required String animal,
    required String temp,
    required String heartRate,
    required List<Map<String, String>> extraVitals,
    required String solution,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "KRISHINET PRESCRIPTION",
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex("#006d24"),
                          ),
                        ),
                        pw.Text(
                          "Agri-Expert Consultation Services",
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Divider(thickness: 2, color: PdfColor.fromHex("#006d24")),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Patient & Client Information",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Farmer Name",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(farmerName),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Farmer Phone",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(farmerPhone),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Animal Type",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(animal),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Vital Measurements",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Body Temp (°F)",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(temp),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Heart Rate (BPM)",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(heartRate),
                        ),
                      ],
                    ),
                    ...extraVitals.map(
                      (v) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              v['name']!,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(v['value']!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Provided Solution / Prescription Notes",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: pw.Text(
                    solution.isNotEmpty
                        ? solution
                        : "No prescription notes entered.",
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),

                pw.Spacer(),
                pw.Divider(color: PdfColors.grey300),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Generated via Krishinet Expert Portal",
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      "Signature of Authorized Expert",
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "prescription_${farmerName.replaceAll(' ', '_')}.pdf",
    );
  }

  void _animalConsultationSheet() {
    String selectedAnimal = 'Cow';
    final List<String> animalOptions = [
      'Cow',
      'Goat',
      'Sheep',
      'Buffalo',
      'Poultry',
    ];
    final symCtrl = TextEditingController();
    final tempCtrl = TextEditingController();
    final heartCtrl = TextEditingController();
    final solutionCtrl = TextEditingController();
    final List<Map<String, dynamic>> extraMeasurements = [];
    TextEditingController? farmerFieldCtrl;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: _bottomSheetContainer(
                  title: "Provide Animal Health Consultation",
                  icon: Icons.pets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Autocomplete<Map<String, String>>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Map<String, String>>.empty();
                          }
                          return _registeredFarmers.where((
                            Map<String, String> option,
                          ) {
                            return option['name']!.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                ) ||
                                option['phone']!.contains(
                                  textEditingValue.text,
                                );
                          });
                        },
                        displayStringForOption:
                            (Map<String, String> option) =>
                                "${option['name']} (${option['phone']})",
                        fieldViewBuilder: (
                          context,
                          controller,
                          focusNode,
                          onFieldSubmitted,
                        ) {
                          farmerFieldCtrl = controller;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Registered Farmer Name/Number *",
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: controller,
                                focusNode: focusNode,
                                onSubmitted: (_) => onFieldSubmitted(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter name or phone number...",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceContainer,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 48,
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    final Map<String, String> option = options
                                        .elementAt(index);
                                    return ListTile(
                                      title: Text(
                                        option['name']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      subtitle: Text(
                                        option['phone']!,
                                        style: const TextStyle(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                      ),
                                      onTap: () {
                                        onSelected(option);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: "Select Animal Type *",
                              value: selectedAnimal,
                              items: animalOptions,
                              onChanged:
                                  (val) => setModalState(
                                    () => selectedAnimal = val!,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final newAnimalCtrl = TextEditingController();
                                  return AlertDialog(
                                    backgroundColor:
                                        AppColors.surfaceContainerHigh,
                                    title: const Text(
                                      "Add New Animal",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: TextField(
                                      controller: newAnimalCtrl,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText:
                                            "Enter animal type (e.g. Rabbit)",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final name =
                                              newAnimalCtrl.text.trim();
                                          if (name.isNotEmpty) {
                                            setModalState(() {
                                              if (!animalOptions.contains(
                                                name,
                                              )) {
                                                animalOptions.add(name);
                                              }
                                              selectedAnimal = name;
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Add",
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              "Body Temp (°F)",
                              tempCtrl,
                              placeholder: "e.g. 101.5",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              "Heart Rate (BPM)",
                              heartCtrl,
                              placeholder: "e.g. 65",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        "Observed Symptoms *",
                        symCtrl,
                        placeholder: "e.g. fever, loss of appetite, coughing",
                      ),
                      ...extraMeasurements.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  m['label'] as String,
                                  m['controller'] as TextEditingController,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                                onPressed:
                                    () => setModalState(
                                      () => extraMeasurements.remove(m),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final labelCtrl = TextEditingController();
                                return AlertDialog(
                                  backgroundColor:
                                      AppColors.surfaceContainerHigh,
                                  title: const Text(
                                    "Add Vital Measurement Metric",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: TextField(
                                    controller: labelCtrl,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText:
                                          "Metric Name (e.g. Blood Pressure)",
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final name = labelCtrl.text.trim();
                                        if (name.isNotEmpty) {
                                          setModalState(() {
                                            extraMeasurements.add({
                                              'label': name,
                                              'controller':
                                                  TextEditingController(),
                                            });
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Add",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            "Add Vital Metric (e.g. Blood Pressure)",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        "Provided Solution (Medicines & Solutions) *",
                        solutionCtrl,
                        placeholder:
                            "Enter medicines, dosages, and solutions...",
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSubmitButton(
                              "Generate PDF",
                              () async {
                                final fName =
                                    farmerFieldCtrl?.text.trim() ?? "";
                                final symptoms = symCtrl.text.trim();
                                final solution = solutionCtrl.text.trim();

                                if (fName.isEmpty ||
                                    symptoms.isEmpty ||
                                    solution.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please fill in all mandatory fields (*)",
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                final phoneMatch = _registeredFarmers
                                    .firstWhere(
                                      (f) => fName.contains(f['name']!),
                                      orElse: () => {},
                                    );
                                final fPhone = phoneMatch['phone'] ?? "N/A";
                                await _generatePrescriptionPdf(
                                  farmerName: fName,
                                  farmerPhone: fPhone,
                                  animal: selectedAnimal,
                                  temp: tempCtrl.text,
                                  heartRate: heartCtrl.text,
                                  extraVitals:
                                      extraMeasurements
                                          .map(
                                            (m) => {
                                              'name': m['label'] as String,
                                              'value':
                                                  (m['controller']
                                                          as TextEditingController)
                                                      .text,
                                            },
                                          )
                                          .toList(),
                                  solution: solution,
                                );
                              },
                              color: AppColors.surfaceContainerHigh,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSubmitButton("Send to Farmer", () {
                              final fName =
                                    farmerFieldCtrl?.text.trim() ?? "";
                              final symptoms = symCtrl.text.trim();
                              final solution = solutionCtrl.text.trim();

                              if (fName.isEmpty ||
                                  symptoms.isEmpty ||
                                  solution.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill in all mandatory fields (*)",
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              Navigator.pop(context);
                              _showSuccess(
                                "Prescription successfully sent to farmer!",
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }  // --- 2. Diagnose Disease Sheet ---
  void _diseaseDiagnosisSheet() {
    bool isScanning = false;
    String? scanResult;
    String selectedType = 'Crop';
    String selectedCrop = 'Paddy';
    String selectedLivestock = 'Cow';

    final List<String> cropOptions = [
      'Paddy',
      'Wheat',
      'Maize',
      'Potato',
      'Jute',
    ];
    final List<String> livestockOptions = [
      'Cow',
      'Goat',
      'Sheep',
      'Buffalo',
      'Poultry',
    ];
    final List<String> selectedImages = [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Diagnose Livestock & Crop Diseases",
              icon: Icons.biotech,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: "Diagnosis Target Type",
                    value: selectedType,
                    items: ['Crop', 'Livestock'],
                    onChanged: (val) {
                      setModalState(() {
                        selectedType = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  if (selectedType == 'Crop')
                    _buildDropdownField(
                      label: "Selected Crop",
                      value: selectedCrop,
                      items: cropOptions,
                      onChanged:
                          (val) => setModalState(() => selectedCrop = val!),
                    )
                  else
                    _buildDropdownField(
                      label: "Selected Livestock",
                      value: selectedLivestock,
                      items: livestockOptions,
                      onChanged:
                          (val) =>
                              setModalState(() => selectedLivestock = val!),
                    ),
                  const SizedBox(height: 16),
                  if (scanResult == null && !isScanning) ...[
                    const Text(
                      "Upload Diagnostic Images (Max 5)",
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedImages.isEmpty)
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "No images selected. Add up to 5 images for analysis.",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              selectedImages.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final imgName = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceContainerHigh,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.image,
                                              color: AppColors.primary,
                                              size: 24,
                                            ),
                                            const SizedBox(height: 4),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4.0,
                                                  ),
                                              child: Text(
                                                imgName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              selectedImages.removeAt(idx);
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (selectedImages.length < 5)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setModalState(() {
                              selectedImages.add(
                                "img_${selectedImages.length + 1}.jpg",
                              );
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add_photo_alternate, size: 18),
                          label: Text(
                            "Add Image (${selectedImages.length}/5)",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            selectedImages.isEmpty
                                ? null
                                : () {
                                  setModalState(() => isScanning = true);
                                  Future.delayed(const Duration(seconds: 2), () {
                                    setModalState(() {
                                      isScanning = false;
                                      scanResult =
                                          selectedType == 'Crop'
                                              ? "Late Blight of Potato detected in $selectedCrop with 92% confidence based on ${selectedImages.length} analyzed images."
                                              : "Foot-and-Mouth Disease (FMD) symptoms matched in $selectedLivestock (89% confidence) based on ${selectedImages.length} analyzed images.";
                                    });
                                  });
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: const Color(0xFF00390E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.analytics, size: 18),
                        label: const Text(
                          "Start AI Diagnosis",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ] else if (isScanning)
                    const SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "AI Diagnostics Engine analyzing images...",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Diagnosis Report Ready",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            scanResult!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Recommended Actions:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedType == 'Crop'
                                ? "• Spray Copper Oxychloride (4 g/L) on $selectedCrop.\n• Destroy infected plants/leaves to limit spore spread."
                                : "• Isolate the $selectedLivestock immediately.\n• Apply potassium permanganate solution to mouth lesions."
                                    "\n• Check other livestock animals in contact.",
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSubmitButton("Reset & Scan New", () {
                      setModalState(() {
                        scanResult = null;
                        selectedImages.clear();
                      });
                    }),
                  ],
                  if (scanResult == null && !isScanning) ...[
                    const SizedBox(height: 12),
                    _buildSubmitButton(
                      "Close Panel",
                      () => Navigator.pop(context),
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

  // --- 3. Schedule Vaccination Sheet ---
  void _vaccineTrainingSheet() {
    String type = 'Vaccination Programme';
    DateTime? selectedDate;
    StateSetter? modalState;
    final dateCtrl = TextEditingController();
    final villageCtrl = TextEditingController();
    final thanaCtrl = TextEditingController();
    final upazilaCtrl = TextEditingController();
    final districtCtrl = TextEditingController();
    String objective = 'Crop';
    final speciesCtrl = TextEditingController();
    final headlineCtrl = TextEditingController();
    final seatsCtrl = TextEditingController(text: "50");

    headlineCtrl.addListener(() {
      if (modalState != null) {
        modalState!(() {});
      }
    });

    String formatDate(DateTime dt) {
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString();
      return "$day-$month-$year";
    }

    void showPosterDialog(
      String category,
      String headline,
      String date,
      String village,
      String thana,
      String upazila,
      String district,
      String objective,
      String species,
    ) {
      Widget buildPosterRow(IconData icon, String label, String value) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF54E167), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFBCCBB7),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF004D40), // Dark teal
                    Color(0xFF00796B), // Teal
                    Color(0xFF00390E), // Forest green
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF54E167), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF54E167),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF00390E),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      children: [
                        const Icon(Icons.eco, color: Color(0xFF54E167), size: 48),
                        const SizedBox(height: 16),
                        Text(
                          headline,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            children: [
                              buildPosterRow(Icons.calendar_today, "DATE", date),
                              const Divider(color: Colors.white12, height: 16),
                              buildPosterRow(
                                Icons.location_on,
                                "VENUE",
                                "$village, $thana, $upazila, $district",
                              ),
                              const Divider(color: Colors.white12, height: 16),
                              buildPosterRow(Icons.flag, "OBJECTIVE", objective),
                              if (species.isNotEmpty) ...[
                                const Divider(color: Colors.white12, height: 16),
                                buildPosterRow(
                                  Icons.pets,
                                  "TARGETED SPECIES",
                                  species,
                                ),
                              ],
                              if (type == 'Farmer Training Class' || type == 'Skill Workshop') ...[
                                const Divider(color: Colors.white12, height: 16),
                                buildPosterRow(
                                  Icons.event_seat,
                                  "MAXIMUM SEATS / REGISTRATION",
                                  seatsCtrl.text.trim(),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          "ORGANIZED BY KRISHINET AGRI-EXPERT TEAM\nALL LOCAL FARMERS ARE INVITED TO PARTICIPATE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFBCCBB7),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.grey),
                          label: const Text(
                            "Close",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Poster sent to local printing service successfully!"),
                                backgroundColor: Color(0xFF2CC04B),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.print),
                          label: const Text("Print Now"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF54E167),
                            foregroundColor: const Color(0xFF00390E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
      );
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            modalState = setModalState;

            return _bottomSheetContainer(
              title: "Schedule Vaccine & Training Programs",
              icon: Icons.vaccines,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownField(
                      label: "Program Category *",
                      value: type,
                      items: [
                        'Vaccination Programme',
                        'Farmer Training Class',
                        'Skill Workshop',
                        'other',
                      ],
                      onChanged: (val) => setModalState(() => type = val!),
                    ),
                    if (type == 'Farmer Training Class' || type == 'Skill Workshop') ...[
                      const SizedBox(height: 12),
                      _buildTextField(
                        "Maximum Seats / Registration *",
                        seatsCtrl,
                        keyboardType: TextInputType.number,
                        placeholder: "e.g. 50",
                      ),
                    ],
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Scheduled Date * (DDMMYYYY)",
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: dateCtrl,
                          readOnly: true,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          onTap: () async {
                            final now = DateTime.now();
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? now,
                              firstDate: DateTime(now.year, now.month, now.day),
                              lastDate: now.add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) {
                              setModalState(() {
                                selectedDate = picked;
                                dateCtrl.text = formatDate(picked);
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "DD-MM-YYYY",
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                            filled: true,
                            fillColor: AppColors.surfaceContainer,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Village *", villageCtrl, placeholder: "e.g. Sreepur Village"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField("Thana *", thanaCtrl, placeholder: "e.g. Sreepur Thana"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Upazila *", upazilaCtrl, placeholder: "e.g. Gazipur Sadar"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField("District *", districtCtrl, placeholder: "e.g. Gazipur"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: "Objective *",
                      value: objective,
                      items: ['Crop', 'Livestock'],
                      onChanged: (val) => setModalState(() => objective = val!),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField("Targeted Species", speciesCtrl, placeholder: "e.g. Cow, Goat, Poultry (Optional)"),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        final words = headlineCtrl.text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              "Headline of the Program *",
                              headlineCtrl,
                              placeholder: "Enter the program headline (within 200 words)...",
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "$words / 200 words",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: words > 200 ? AppColors.error : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final date = dateCtrl.text.trim();
                              final village = villageCtrl.text.trim();
                              final thana = thanaCtrl.text.trim();
                              final upazila = upazilaCtrl.text.trim();
                              final district = districtCtrl.text.trim();
                              final headline = headlineCtrl.text.trim();
                              final needsSeats = (type == 'Farmer Training Class' || type == 'Skill Workshop');
                              final seats = seatsCtrl.text.trim();

                              if (date.isEmpty ||
                                  village.isEmpty ||
                                  thana.isEmpty ||
                                  upazila.isEmpty ||
                                  district.isEmpty ||
                                  headline.isEmpty ||
                                  (needsSeats && seats.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please fill in all mandatory fields (*)"),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              final words = headline.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
                              if (words > 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Headline must be within 200 words."),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              showPosterDialog(
                                type,
                                headline,
                                date,
                                village,
                                thana,
                                upazila,
                                district,
                                objective,
                                speciesCtrl.text.trim(),
                              );
                            },
                            icon: const Icon(Icons.print, size: 18),
                            label: const Text("Print Poster"),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary, width: 1.5),
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final date = dateCtrl.text.trim();
                              final village = villageCtrl.text.trim();
                              final thana = thanaCtrl.text.trim();
                              final upazila = upazilaCtrl.text.trim();
                              final district = districtCtrl.text.trim();
                              final headline = headlineCtrl.text.trim();
                              final needsSeats = (type == 'Farmer Training Class' || type == 'Skill Workshop');
                              final seats = seatsCtrl.text.trim();

                              if (date.isEmpty ||
                                  village.isEmpty ||
                                  thana.isEmpty ||
                                  upazila.isEmpty ||
                                  district.isEmpty ||
                                  headline.isEmpty ||
                                  (needsSeats && seats.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please fill in all mandatory fields (*)"),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              final words = headline.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
                              if (words > 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Headline must be within 200 words."),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              Navigator.pop(context);
                              _showSuccess(
                                "New $type scheduled and notifications broadcasted to farmers!",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: const Color(0xFF00390E),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              "Publish Schedule",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 5. Disease or Disaster Alert Sheet ---
  void _emergencyOutbreakSheet() {
    String alertType = 'Disease'; // 'Disease' or 'Disaster'
    String selectedOption = 'Lumpy Skin Disease (LSD)';
    final locCtrl = TextEditingController();
    final countCtrl = TextEditingController(text: "15");
    final precautionCtrl = TextEditingController();
    String severity = 'High';

    final List<String> diseaseOptions = [
      'Lumpy Skin Disease (LSD)',
      'Anthrax',
      'PPR Outbreak',
      'Bird Flu (Avian Influenza)',
      'Late Blight (Potato)',
      'Foot and Mouth Disease (FMD)',
      'Rice Blast Disease',
      'Bacterial Leaf Blight',
      'Newcastle Disease',
      'Black Quarter',
    ];

    final List<String> disasterOptions = [
      'Flash Flood',
      'Cyclone',
      'Severe Drought',
      'Hailstorm',
      'Tornado',
      'Riverbank Erosion',
      'Cold Wave',
      'Heat Wave',
      'Pest Invasion (Locusts)',
      'Landslide',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Report Disease or Disaster Alert",
              icon: Icons.warning_amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.gpp_maybe, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "CRITICAL: $alertType alerts are reported immediately to the Upazila Command Office and relevant Ministry.",
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDropdownField(
                    label: "Select Disaster or Disease",
                    value: alertType,
                    items: ['Disease', 'Disaster'],
                    onChanged: (val) => setModalState(() {
                      alertType = val!;
                      // Automatically reset to the first option when switching types
                      selectedOption = alertType == 'Disease'
                          ? diseaseOptions.first
                          : disasterOptions.first;
                    }),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: alertType == 'Disease' ? "Select Disease" : "Select Disaster",
                    value: selectedOption,
                    items: alertType == 'Disease' ? diseaseOptions : disasterOptions,
                    onChanged: (val) => setModalState(() => selectedOption = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Affected Area *",
                    locCtrl,
                    placeholder: "e.g. Ward 4, Singair, Manikganj",
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    alertType == 'Disease' ? "Est. Infected Animal *" : "Est. Damaged Crop Land *",
                    countCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Precautions / Cure *",
                    precautionCtrl,
                    placeholder: "e.g. Isolate infected cattle, vaccinate surrounding herds.",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: "Severity Rating",
                    value: severity,
                    items: ['Low', 'Medium', 'High', 'Critical'],
                    onChanged: (val) => setModalState(() => severity = val!),
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton("File Disease or Disaster Alert", () {
                    final affectedArea = locCtrl.text.trim();
                    final estCount = countCtrl.text.trim();
                    final precautions = precautionCtrl.text.trim();

                    if (affectedArea.isEmpty || estCount.isEmpty || precautions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all mandatory fields (*)"),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    _showSuccess(
                      "${alertType.toUpperCase()} Alert filed. Threat vectors registered with Upazila Command Office!",
                    );
                  }, color: AppColors.primary),
                ],
              ),
            );
          },
        );
      },
    );
  }











  // --- 12. Deliver Soil Testing & Recommendations ---
  void _soilTestingSheet() {
    final phCtrl = TextEditingController(text: "6.2");
    final nCtrl = TextEditingController(text: "15");
    final pCtrl = TextEditingController(text: "22");
    final kCtrl = TextEditingController(text: "85");
    String output = "";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: _bottomSheetContainer(
                title: "Deliver Soil Testing & Recommendations",
                icon: Icons.science,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Soil pH Level",
                            phCtrl,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Nitrogen N (ppm)",
                            nCtrl,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Phosphorus P (ppm)",
                            pCtrl,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Potassium K (ppm)",
                            kCtrl,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (output.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          output,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    _buildSubmitButton("Generate Soil Diagnostics", () {
                      final ph = double.tryParse(phCtrl.text) ?? 6.0;
                      final n = double.tryParse(nCtrl.text) ?? 15.0;
                      final p = double.tryParse(pCtrl.text) ?? 20.0;

                      setModalState(() {
                        String pHStatus =
                            ph < 5.5
                                ? "Very Acidic"
                                : (ph > 7.5 ? "Alkaline" : "Neutral/Ideal");
                        output =
                            "Soil Test Results analysis:\n"
                            "• Acidic Level: $pHStatus ($ph)\n"
                            "• Nitrogen: ${n < 20 ? 'Deficient' : 'Satisfactory'}\n"
                            "• Phosphorus: ${p < 25 ? 'Low' : 'Adequate'}\n\n"
                            "Recommendations:\n"
                            "${ph < 5.5 ? '• Apply lime (Dolomite) at 400 kg/acre to neutralize acidity.\n' : ''}"
                            "${n < 20 ? '• Add Urea or organic manure to boost Nitrogen.\n' : ''}"
                            "• Plan crop rotation with legume crops (lentils) next season.";
                      });
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 13. Upload research documents ---
  void _uploadAdvisorySheet() {
    final titleCtrl = TextEditingController(
      text: "Mitigating Salinity in Coastal Fields",
    );
    String selectedCat = "Agronomy";
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Upload Research‑Based Advisory Documents",
              icon: Icons.cloud_upload,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Document Title", titleCtrl),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: "Scientific Category",
                    value: selectedCat,
                    items: [
                      'Agronomy',
                      'Soil Science',
                      'Veterinary Medicine',
                      'Fisheries & Aquaculture',
                    ],
                    onChanged: (val) => setModalState(() => selectedCat = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Short Summary",
                    descCtrl,
                    placeholder:
                        "e.g. Analysis of salinity tolerant Boro varieties in Satkhira",
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton("Upload Advisory Document (PDF/DOC)", () {
                    Navigator.pop(context);
                    _showSuccess(
                      "Research Advisory successfully published to regional Farmer Portals!",
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }



  // --- Shared Helper UI Builders ---
  Widget _bottomSheetContainer({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? placeholder,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: AppColors.surfaceContainerHigh,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
    String text,
    VoidCallback onPressed, {
    Color color = AppColors.primary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor:
              color == AppColors.primary
                  ? const Color(0xFF00390E)
                  : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 12 toolkit items list
    final List<Map<String, dynamic>> tools = [
      {
        'title': 'Animal Consultation',
        'desc': 'Provide animal health consultation',
        'icon': Icons.pets,
        'action': _animalConsultationSheet,
      },
      {
        'title': 'Disease Diagnosis',
        'desc': 'Diagnose livestock & crop diseases',
        'icon': Icons.biotech,
        'action': _diseaseDiagnosisSheet,
      },
      {
        'title': 'Vaccine Programs',
        'desc': 'Schedule vaccination & training programs',
        'icon': Icons.vaccines,
        'action': _vaccineTrainingSheet,
      },
      {
        'title': 'Disease or Disaster Alert',
        'desc': 'Report emergency disease outbreaks or natural disasters',
        'icon': Icons.warning_amber,
        'action': _emergencyOutbreakSheet,
      },
      {
        'title': 'Soil Recommendations',
        'desc': 'Deliver soil testing & recommendations',
        'icon': Icons.science,
        'action': _soilTestingSheet,
      },
      {
        'title': 'Research Documents',
        'desc': 'Upload research-based advisory docs',
        'icon': Icons.cloud_upload,
        'action': _uploadAdvisorySheet,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final t = tools[index];
            return Container(
              decoration: BoxDecoration(
                color: Color.lerp(
                  AppColors.surfaceContainer,
                  AppColors.primary,
                  0.05,
                )!.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: t['action'] as VoidCallback,
                  splashColor: AppColors.primary.withValues(alpha: 0.1),
                  highlightColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          t['icon'] as IconData,
                          size: 56,
                          color: Colors.white.withValues(alpha: 0.03),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            2,
                            (r) => Row(
                              children: List.generate(
                                3,
                                (c) => Container(
                                  width: 2.5,
                                  height: 2.5,
                                  margin: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                t['icon'] as IconData,
                                color: AppColors.primary,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
    );
  }
}

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
              onPressed: onAppointmentTap,
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
          subtitle: 'Farmer: Kalam Miah • 10:00 AM',
          onTap: onAppointmentTap,
        ),
        const SizedBox(height: 12),
        _buildAppointmentCard(
          icon: Icons.pest_control,
          iconBgColor: AppColors.primaryContainer.withValues(alpha: 0.1),
          iconColor: AppColors.primary.withValues(alpha: 0.8),
          title: 'Pest Outbreak Analysis',
          subtitle: 'Farmer: Sufia Begum • 01:30 PM',
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
              _buildNavItem(0, Icons.home, 'HOME'),
              _buildNavItem(1, Icons.today, 'APPOINTMENTS'),
              _buildNavItem(2, Icons.chat_bubble_outline, 'CHAT'),
              _buildNavItem(3, Icons.account_balance_outlined, 'GOV PORTAL'),
              _buildNavItem(4, Icons.person_outline, 'PROFILE'),
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
