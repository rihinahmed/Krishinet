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
                  const ExpertToolkitSection(),
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
class ExpertToolkitSection extends StatefulWidget {
  const ExpertToolkitSection({super.key});

  @override
  State<ExpertToolkitSection> createState() => _ExpertToolkitSectionState();
}

class _ExpertToolkitSectionState extends State<ExpertToolkitSection> {
  // Form controllers / mock data states
  final List<Map<String, dynamic>> _mockLivestockRecords = [
    {'id': 'LIV-4012', 'type': 'Cow (Friesian)', 'age': '2.5 years', 'status': 'Healthy', 'owner': 'Karim Miah', 'vax': 'FMD, Anthrax'},
    {'id': 'LIV-8821', 'type': 'Goat (Black Bengal)', 'age': '1.2 years', 'status': 'Under Treatment', 'owner': 'Rihin Farmer', 'vax': 'PPR'},
    {'id': 'LIV-1092', 'type': 'Buffalo', 'age': '4.0 years', 'status': 'Healthy', 'owner': 'Mitu Khatun', 'vax': 'FMD'},
  ];

  final List<Map<String, dynamic>> _mockSoilRecords = [
    {'plot': 'Plot #09', 'owner': 'Kalam Miah', 'ph': '6.4', 'npk': 'N: Low, P: Med, K: High', 'crop': 'Boro Paddy'},
    {'plot': 'Plot #42', 'owner': 'Tufan Ali', 'ph': '5.8', 'npk': 'N: High, P: Low, K: Med', 'crop': 'Potato'},
    {'plot': 'Plot #11', 'owner': 'Sufia Begum', 'ph': '7.2', 'npk': 'N: Med, P: Med, K: Med', 'crop': 'Aman Paddy'},
  ];

  final List<Map<String, dynamic>> _mockFarmerQueries = [
    {'id': 'Q-901', 'farmer': 'Selim Khan', 'query': 'Tomato leaf edges are turning brown and crispy. Is it potassium deficiency?', 'crop': 'Tomato', 'date': '2 hrs ago', 'replied': false},
    {'id': 'Q-772', 'farmer': 'Abdul Baten', 'query': 'My cow has lost appetite and has small nodules on its neck. What could it be?', 'crop': 'Livestock', 'date': '1 day ago', 'replied': false},
    {'id': 'Q-104', 'farmer': 'Amena Bibi', 'query': 'When is the best time to apply gypsum in maize fields for maximum yield?', 'crop': 'Maize', 'date': '2 days ago', 'replied': true, 'reply': 'Apply 40 kg per acre during land preparation.'},
  ];

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
  void _animalConsultationSheet() {
    String selectedAnimal = 'Cow';
    final symCtrl = TextEditingController();
    final tempCtrl = TextEditingController(text: '101.5');
    final heartCtrl = TextEditingController(text: '65');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Provide Animal Health Consultation",
              icon: Icons.pets,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: "Select Animal Type",
                    value: selectedAnimal,
                    items: ['Cow', 'Goat', 'Sheep', 'Buffalo', 'Poultry'],
                    onChanged: (val) => setModalState(() => selectedAnimal = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("Observed Symptoms", symCtrl, placeholder: "e.g. fever, loss of appetite, coughing"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Body Temp (°F)", tempCtrl, keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField("Heart Rate (BPM)", heartCtrl, keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton("Generate Treatment Plan", () {
                    Navigator.pop(context);
                    _showSuccess("Consultation details saved. Diagnosis: Mild infection. Prescription sent to owner!");
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 2. Diagnose Disease Sheet ---
  void _diseaseDiagnosisSheet() {
    bool isScanning = false;
    String? scanResult;
    String selectedType = 'Crop';

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
                    onChanged: (val) => setModalState(() => selectedType = val!),
                  ),
                  const SizedBox(height: 16),
                  if (scanResult == null && !isScanning)
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_upload_outlined, color: AppColors.onSurfaceVariant, size: 48),
                          const SizedBox(height: 12),
                          const Text("No image selected for scanning", style: TextStyle(color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              setModalState(() => isScanning = true);
                              Future.delayed(const Duration(seconds: 2), () {
                                setModalState(() {
                                  isScanning = false;
                                  scanResult = selectedType == 'Crop' 
                                      ? "Late Blight of Potato detected with 92% confidence." 
                                      : "Foot-and-Mouth Disease (FMD) symptoms matched (89% confidence).";
                                });
                              });
                            },
                            icon: const Icon(Icons.camera_alt, color: AppColors.primary),
                            label: const Text("Capture / Upload Image", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )
                  else if (isScanning)
                    const SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                          SizedBox(height: 16),
                          Text("AI Diagnostics Engine analyzing image...", style: TextStyle(color: AppColors.primary)),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text("Diagnosis Report Ready", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(scanResult!, style: const TextStyle(fontSize: 14, color: AppColors.onBackground)),
                          const SizedBox(height: 12),
                          const Text("Recommended Actions:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                          const SizedBox(height: 4),
                          Text(
                            selectedType == 'Crop'
                                ? "• Spray Copper Oxychloride (4 g/L).\n• Destroy infected plants to limit spore spread."
                                : "• Isolate the animal immediately.\n• Apply potassium permanganate solution to mouth lesions.",
                            style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (scanResult != null)
                    _buildSubmitButton("Reset & Scan New", () {
                      setModalState(() {
                        scanResult = null;
                      });
                    })
                  else
                    _buildSubmitButton("Close Panel", () => Navigator.pop(context)),
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
    String type = 'Vaccination Drive';
    final dateCtrl = TextEditingController(text: "2026-08-01");
    final locationCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: "Cows & Goats");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Schedule Vaccine & Training Programs",
              icon: Icons.vaccines,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: "Program Category",
                    value: type,
                    items: ['Vaccination Drive', 'Farmer Training Class', 'Outreach Workshop'],
                    onChanged: (val) => setModalState(() => type = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("Scheduled Date (YYYY-MM-DD)", dateCtrl),
                  const SizedBox(height: 12),
                  _buildTextField("Target Union / Location", locationCtrl, placeholder: "e.g. Sreepur, Union Parishad Hall"),
                  const SizedBox(height: 12),
                  _buildTextField("Target Crop/Livestock Group", targetCtrl),
                  const SizedBox(height: 20),
                  _buildSubmitButton("Publish Program Schedule", () {
                    Navigator.pop(context);
                    _showSuccess("New $type scheduled and notifications broadcasted to farmers!");
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 4. Upload Prescription Sheet ---
  void _uploadPrescriptionSheet() {
    final fidCtrl = TextEditingController(text: "KM-2026-8913");
    final rxCtrl = TextEditingController();
    final dosageCtrl = TextEditingController(text: "2 tablets twice daily for 5 days");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _bottomSheetContainer(
          title: "Upload Prescription & Advisory Notes",
          icon: Icons.note_add,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Farmer ID / Phone", fidCtrl),
              const SizedBox(height: 12),
              _buildTextField("Prescribed Medicines / Treatment", rxCtrl, placeholder: "e.g. Albendazole 600mg dewormer"),
              const SizedBox(height: 12),
              _buildTextField("Dosage & Directions", dosageCtrl),
              const SizedBox(height: 20),
              _buildSubmitButton("Send Prescription Note", () {
                Navigator.pop(context);
                _showSuccess("Prescription successfully sent to farmer ${fidCtrl.text} via SMS!");
              }),
            ],
          ),
        );
      },
    );
  }

  // --- 5. Emergency Outbreak Sheet ---
  void _emergencyOutbreakSheet() {
    String disease = 'Lumpy Skin Disease (LSD)';
    final locCtrl = TextEditingController();
    final countCtrl = TextEditingController(text: "15");
    String severity = 'High';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Report Emergency Disease Outbreak",
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
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.gpp_maybe, color: AppColors.error),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "CRITICAL: Outbreaks are reported immediately to the Ministry of Livestock & Agriculture.",
                            style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDropdownField(
                    label: "Select Disease Outbreak",
                    value: disease,
                    items: ['Lumpy Skin Disease (LSD)', 'Anthrax', 'PPR Outbreak', 'Bird Flu (Avian Influenza)', 'Late Blight Pandemic'],
                    onChanged: (val) => setModalState(() => disease = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("Exact Village / Word / Zone", locCtrl, placeholder: "e.g. Ward 4, Singair, Manikganj"),
                  const SizedBox(height: 12),
                  _buildTextField("Est. Infected Animals/Crops", countCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: "Severity Rating",
                    value: severity,
                    items: ['Low', 'Medium', 'High', 'Critical'],
                    onChanged: (val) => setModalState(() => severity = val!),
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton("File Emergency Threat Alert", () {
                    Navigator.pop(context);
                    _showSuccess("EMERGENCY Alert filed. Threat vectors registered with Upazila Command Office!");
                  }, color: AppColors.error),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 6. Fertilizer & Feed Recommendations ---
  void _fertilizerFeedSheet() {
    String type = 'Crop (Fertilizer)';
    final cropCtrl = TextEditingController(text: "Boro Paddy");
    final decimalCtrl = TextEditingController(text: "100");
    String output = "";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Recommend Fertilizer & Feed Usage",
              icon: Icons.grass,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: "Recommendation Type",
                    value: type,
                    items: ['Crop (Fertilizer)', 'Livestock (Feed Chart)'],
                    onChanged: (val) => setModalState(() {
                      type = val!;
                      cropCtrl.text = type == 'Crop (Fertilizer)' ? "Boro Paddy" : "Dairy Cow";
                    }),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(type == 'Crop (Fertilizer)' ? "Crop Name" : "Animal Breed/Category", cropCtrl),
                  const SizedBox(height: 12),
                  _buildTextField(type == 'Crop (Fertilizer)' ? "Land Area (Decimals)" : "Number of Animals / Daily Yield", decimalCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  if (output.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Calculated Recommendation:", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 8),
                          Text(output, style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.white)),
                        ],
                      ),
                    ),
                  _buildSubmitButton("Calculate Accents & Dosages", () {
                    final dec = double.tryParse(decimalCtrl.text) ?? 100;
                    setModalState(() {
                      if (type == 'Crop (Fertilizer)') {
                        output = "For ${cropCtrl.text} on $dec decimals:\n"
                            "• Urea: ${(dec * 0.85).toStringAsFixed(1)} kg\n"
                            "• TSP: ${(dec * 0.45).toStringAsFixed(1)} kg\n"
                            "• MOP: ${(dec * 0.50).toStringAsFixed(1)} kg\n"
                            "• Gypsum: ${(dec * 0.20).toStringAsFixed(1)} kg";
                      } else {
                        output = "For ${cropCtrl.text} ($dec units):\n"
                            "• Green Fodder: ${(dec * 15).toStringAsFixed(0)} kg daily\n"
                            "• Dry Straw: ${(dec * 4).toStringAsFixed(0)} kg daily\n"
                            "• Concentrate Mix: ${(dec * 3.5).toStringAsFixed(1)} kg daily\n"
                            "• Mineral Supplements: ${(dec * 100).toStringAsFixed(0)} g daily";
                      }
                    });
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 7. Conduct Farmer Workshops Sheet ---
  void _farmerWorkshopSheet() {
    final titleCtrl = TextEditingController(text: "Integrated Pest Management (IPM)");
    final countCtrl = TextEditingController(text: "30");
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _bottomSheetContainer(
          title: "Conduct Farmer Training Workshops",
          icon: Icons.co_present,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Workshop Topic", titleCtrl),
              const SizedBox(height: 12),
              _buildTextField("Maximum Seats / Registrations", countCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Syllabus & Core Objectives", descCtrl, placeholder: "e.g. Teaching biological insect traps, pheromone traps setup"),
              const SizedBox(height: 20),
              _buildSubmitButton("Open Workshop Registrations", () {
                Navigator.pop(context);
                _showSuccess("Training Workshop created! Invitations pushed to local Union farmer boards.");
              }),
            ],
          ),
        );
      },
    );
  }

  // --- 8. Maintain Livestock Records Sheet ---
  void _livestockRecordsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Livestock Health Records Ledger",
              icon: Icons.history_edu,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      itemCount: _mockLivestockRecords.length,
                      itemBuilder: (context, index) {
                        final rec = _mockLivestockRecords[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(rec['type']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text("Owner: ${rec['owner']} | Age: ${rec['age']}", style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                                  Text("Vaccines: ${rec['vax']}", style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: rec['status'] == 'Healthy' ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFFF5252).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  rec['status']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: rec['status'] == 'Healthy' ? AppColors.primary : const Color(0xFFFF5252),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSubmitButton("Create New Livestock Profile", () {
                    setModalState(() {
                      _mockLivestockRecords.add({
                        'id': 'LIV-${1000 + (DateTime.now().millisecondsSinceEpoch % 8999)}',
                        'type': 'Goat (Jamunapari)',
                        'age': '1.5 years',
                        'status': 'Healthy',
                        'owner': 'Jashim Uddin',
                        'vax': 'PPR, Goat Pox'
                      });
                    });
                    _showSuccess("Added Jamunapari profile to ledger!");
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 9. Maintain Soil & Crop Records Sheet ---
  void _soilCropRecordsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Soil Chemistry & Crop History",
              icon: Icons.layers,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      itemCount: _mockSoilRecords.length,
                      itemBuilder: (context, index) {
                        final rec = _mockSoilRecords[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rec['plot']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text("Farmer: ${rec['owner']} | Target Crop: ${rec['crop']}", style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                                  Text("NPK: ${rec['npk']}", style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("pH LEVEL", style: TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
                                  Text(rec['ph']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSubmitButton("Register New Plot Analysis", () {
                    setModalState(() {
                      _mockSoilRecords.add({
                        'plot': 'Plot #${12 + (DateTime.now().millisecond % 80)}',
                        'owner': 'Jalal Ahmed',
                        'ph': (5.0 + (DateTime.now().millisecond / 1000.0) * 2.5).toStringAsFixed(1),
                        'npk': 'N: Low, P: High, K: Med',
                        'crop': 'Wheat'
                      });
                    });
                    _showSuccess("Soil analysis plot registered!");
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 10. Offer Pest Outbreak Alerts ---
  void _pestAlertSheet() {
    String selectedPest = 'Brown Planthopper (Rice)';
    final radiusCtrl = TextEditingController(text: "5");
    final alertTextCtrl = TextEditingController(text: "Brown planthopper warning in your region. Check base of plants daily.");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Send Pest Outbreak Alerts",
              icon: Icons.bug_report,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: "Detected Pest / Vector",
                    value: selectedPest,
                    items: ['Brown Planthopper (Rice)', 'Fall Armyworm (Maize)', 'Potato Tuber Moth', 'Fruit Fly (Mango)', 'Stem Borer'],
                    onChanged: (val) => setModalState(() => selectedPest = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("Alert Radius (km)", radiusCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField("Alert Broadcast Text", alertTextCtrl),
                  const SizedBox(height: 20),
                  _buildSubmitButton("Broadcast Outbreak SMS Alert", () {
                    Navigator.pop(context);
                    _showSuccess("Emergency Pest Warning sent to all farmers within ${radiusCtrl.text} km!");
                  }, color: const Color(0xFFFF5252)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 11. Seasonal Crop Planning Advice ---
  void _cropPlanningSheet() {
    String selectedSeason = 'Rabi (Winter)';
    String recommendations = "";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Seasonal Crop Planning Guide",
              icon: Icons.calendar_view_month,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(
                    label: "Select Farming Season",
                    value: selectedSeason,
                    items: ['Kharif-1 (Early Summer)', 'Kharif-2 (Monsoon)', 'Rabi (Winter)'],
                    onChanged: (val) => setModalState(() {
                      selectedSeason = val!;
                      recommendations = "";
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (recommendations.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Text(recommendations, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.white)),
                    ),
                  _buildSubmitButton("Retrieve Recommended Crop Guide", () {
                    setModalState(() {
                      if (selectedSeason.contains('Rabi')) {
                        recommendations = "Rabi (Winter) Planning Advice:\n"
                            "• Highly Recommended Crops: Boro Paddy, Wheat, Potato, Lentils, Mustard.\n"
                            "• Irrigation: Needs controlled application. Clayey soil should be watered every 15 days.\n"
                            "• Pest Alert: High likelihood of Late Blight in potato fields due to heavy fog.";
                      } else if (selectedSeason.contains('Kharif-1')) {
                        recommendations = "Kharif-1 (Early Summer) Planning Advice:\n"
                            "• Highly Recommended Crops: Aus Paddy, Jute, Maize, Sesame.\n"
                            "• Irrigation: Prepare for summer thunderstorms. Build cross-channel drains.\n"
                            "• Pest Alert: Stem borer threat in young Aus crops.";
                      } else {
                        recommendations = "Kharif-2 (Monsoon) Planning Advice:\n"
                            "• Highly Recommended Crops: Aman Paddy, Jute, Floating Vegetables.\n"
                            "• Irrigation: Flood safety drains needed. Keep fields under constant monitor.\n"
                            "• Pest Alert: Rice Blast infection rises with monsoon humidity.";
                      }
                    });
                  }),
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
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _bottomSheetContainer(
                title: "Deliver Soil Testing & Recommendations",
                icon: Icons.science,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildTextField("Soil pH Level", phCtrl, keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField("Nitrogen N (ppm)", nCtrl, keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField("Phosphorus P (ppm)", pCtrl, keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField("Potassium K (ppm)", kCtrl, keyboardType: TextInputType.number)),
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
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(output, style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.white)),
                      ),
                    _buildSubmitButton("Generate Soil Diagnostics", () {
                      final ph = double.tryParse(phCtrl.text) ?? 6.0;
                      final n = double.tryParse(nCtrl.text) ?? 15.0;
                      final p = double.tryParse(pCtrl.text) ?? 20.0;
                      
                      setModalState(() {
                        String pHStatus = ph < 5.5 ? "Very Acidic" : (ph > 7.5 ? "Alkaline" : "Neutral/Ideal");
                        output = "Soil Test Results analysis:\n"
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
    final titleCtrl = TextEditingController(text: "Mitigating Salinity in Coastal Fields");
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
                    items: ['Agronomy', 'Soil Science', 'Veterinary Medicine', 'Fisheries & Aquaculture'],
                    onChanged: (val) => setModalState(() => selectedCat = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("Short Summary", descCtrl, placeholder: "e.g. Analysis of salinity tolerant Boro varieties in Satkhira"),
                  const SizedBox(height: 20),
                  _buildSubmitButton("Upload Advisory Document (PDF/DOC)", () {
                    Navigator.pop(context);
                    _showSuccess("Research Advisory successfully published to regional Farmer Portals!");
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 14. Respond to Farmer Queries Sheet ---
  void _farmerQueriesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _bottomSheetContainer(
              title: "Respond to Farmer Queries Directly",
              icon: Icons.question_answer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: _mockFarmerQueries.length,
                      itemBuilder: (context, index) {
                        final q = _mockFarmerQueries[index];
                        final isReplied = q['replied'] as bool;
                        final responseCtrl = TextEditingController();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(q['farmer']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13)),
                                  Text(q['date']!, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(q['query']!, style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.white)),
                              const Divider(color: Colors.white12, height: 16),
                              if (isReplied)
                                Text("Your Reply: ${q['reply']}", style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant))
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: responseCtrl,
                                        style: const TextStyle(fontSize: 11, color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: "Type reply here...",
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 11),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          filled: true,
                                          fillColor: AppColors.surfaceContainer,
                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        final txt = responseCtrl.text.trim();
                                        if (txt.isEmpty) return;
                                        setModalState(() {
                                          q['replied'] = true;
                                          q['reply'] = txt;
                                        });
                                        _showSuccess("Reply sent to ${q['farmer']}!");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: const Color(0xFF00390E),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        minimumSize: const Size(60, 30),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      child: const Text("Send", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSubmitButton("Close Inbox", () => Navigator.pop(context)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 15. Suggest Modern Farming Techniques Sheet ---
  void _farmingTechniquesSheet() {
    final List<Map<String, String>> techniques = [
      {'title': 'Hydroponic Vegetable Grow systems', 'desc': 'Grow high-value capsicum and lettuce in nutrient solutions without soil. Saves 90% water and yields 3x faster.'},
      {'title': 'Drip & Micro-Sprinkler Systems', 'desc': 'Precision fertilizer injection (fertigation) directly to the root zone via automated drip tubes.'},
      {'title': 'Precision Drone NDVI Scanning', 'desc': 'Scan crop fields with multispectral cameras to identify nitrogen gaps before the visual yellowing occurs.'},
      {'title': 'Integrated Pest Management (IPM)', 'desc': 'Use pheromone traps and yellow sticky boards instead of synthetic chemical sprays.'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _bottomSheetContainer(
          title: "Suggest Modern Farming Techniques",
          icon: Icons.lightbulb_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: techniques.length,
                  itemBuilder: (context, index) {
                    final tech = techniques[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.stars, color: AppColors.primary, size: 16),
                              const SizedBox(width: 6),
                              Text(tech['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(tech['desc']!, style: const TextStyle(fontSize: 11, height: 1.4, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildSubmitButton("Close Guide", () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }

  // --- Shared Helper UI Builders ---
  Widget _bottomSheetContainer({required String title, required IconData icon, required Widget child}) {
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

  Widget _buildTextField(String label, TextEditingController controller, {String? placeholder, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColors.surfaceContainerHigh,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(String text, VoidCallback onPressed, {Color color = AppColors.primary}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: color == AppColors.primary ? const Color(0xFF00390E) : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 15 toolkit items list
    final List<Map<String, dynamic>> tools = [
      {'title': 'Animal Consultation', 'desc': 'Provide animal health consultation', 'icon': Icons.pets, 'action': _animalConsultationSheet},
      {'title': 'Disease Diagnosis', 'desc': 'Diagnose livestock & crop diseases', 'icon': Icons.biotech, 'action': _diseaseDiagnosisSheet},
      {'title': 'Vaccine Programs', 'desc': 'Schedule vaccination & training programs', 'icon': Icons.vaccines, 'action': _vaccineTrainingSheet},
      {'title': 'Advisory Prescriptions', 'desc': 'Upload prescriptions & advisory notes', 'icon': Icons.note_add, 'action': _uploadPrescriptionSheet},
      {'title': 'Emergency Outbreaks', 'desc': 'Report emergency disease outbreaks', 'icon': Icons.warning_amber, 'action': _emergencyOutbreakSheet},
      {'title': 'Fertilizer & Feed Guide', 'desc': 'Recommend fertilizer & feed usage', 'icon': Icons.grass, 'action': _fertilizerFeedSheet},
      {'title': 'Farmer Workshops', 'desc': 'Conduct farmer training workshops', 'icon': Icons.co_present, 'action': _farmerWorkshopSheet},
      {'title': 'Livestock Ledgers', 'desc': 'Maintain livestock health records', 'icon': Icons.history_edu, 'action': _livestockRecordsSheet},
      {'title': 'Soil & Crop Registry', 'desc': 'Maintain soil & crop records', 'icon': Icons.layers, 'action': _soilCropRecordsSheet},
      {'title': 'Pest Warning Alerts', 'desc': 'Offer pest outbreak alerts', 'icon': Icons.bug_report, 'action': _pestAlertSheet},
      {'title': 'Seasonal Crop Plans', 'desc': 'Provide seasonal crop planning advice', 'icon': Icons.calendar_view_month, 'action': _cropPlanningSheet},
      {'title': 'Soil Recommendations', 'desc': 'Deliver soil testing & recommendations', 'icon': Icons.science, 'action': _soilTestingSheet},
      {'title': 'Research Documents', 'desc': 'Upload research-based advisory docs', 'icon': Icons.cloud_upload, 'action': _uploadAdvisorySheet},
      {'title': 'Farmer Inbox Direct', 'desc': 'Respond to farmer queries directly', 'icon': Icons.question_answer, 'action': _farmerQueriesSheet},
      {'title': 'Modern Tech Advice', 'desc': 'Suggest modern farming techniques', 'icon': Icons.lightbulb_outline, 'action': _farmingTechniquesSheet},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Expert Service Toolkit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
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
            return GlassCard(
              padding: const EdgeInsets.all(12),
              onTap: t['action'] as VoidCallback,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(t['icon'] as IconData, color: AppColors.primary, size: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t['desc'] as String,
                        style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
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
                name: 'Selim Rahman',
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
                name: 'Mina Khatun',
                status: '2m ago',
                imageUrl:
                    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=150&q=80',
                statusColor: AppColors.secondary,
                onTap: onChatTap,
              ),
              const SizedBox(width: 16),
              _buildChatItem(
                name: 'Kabir U.',
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
              _buildNavItem(0, Icons.home, 'HOME'),
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
