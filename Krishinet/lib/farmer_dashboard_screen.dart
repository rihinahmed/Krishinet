import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  bool _showAiPanel = false;
  int _selectedIndex = 0;

  final List<Map<String, String>> _farmerListings = [
    {
      'crop': "Paddy Rice (Basmati)",
      'demandedQty': "50 Quintals",
      'price': "৳3,100 / q",
      'location': "Punjab Mandi",
      'buyerName': "Deepak Traders",
    },
    {
      'crop': "Wheat Grade A",
      'demandedQty': "100 Quintals",
      'price': "৳2,450 / q",
      'location': "Haryana Grain Market",
      'buyerName': "Agritech Foods",
    },
    {
      'crop': "Potatoes (Jyoti)",
      'demandedQty': "30 Quintals",
      'price': "৳1,200 / q",
      'location': "Kolkata Hub",
      'buyerName': "Roy Cold Storage",
    },
  ];

  void _showSoilCareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF122131),
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
              Row(
                children: [
                  const Icon(Icons.grass, color: Color(0xFF54E167), size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Soil Care Diagnostics",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              _buildSoilParameter(
                "Nitrogen (N)",
                "Target: 60-80 kg/ha",
                "Current: 65 kg/ha",
                const Color(0xFF54E167),
              ),
              const SizedBox(height: 12),
              _buildSoilParameter(
                "Phosphorus (P)",
                "Target: 40-50 kg/ha",
                "Current: 44 kg/ha",
                const Color(0xFF54E167),
              ),
              const SizedBox(height: 12),
              _buildSoilParameter(
                "Potassium (K)",
                "Target: 80-100 kg/ha",
                "Current: 72 kg/ha (Low)",
                Colors.amber,
              ),
              const SizedBox(height: 20),
              Text(
                "Recommendation: Apply Potassium-rich fertilizer (e.g. Muriate of Potash) or farmyard manure.",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFBCCBB7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSoilParameter(
    String label,
    String target,
    String current,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              target,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFBCCBB7),
                fontSize: 11,
              ),
            ),
          ],
        ),
        Text(
          current,
          style:
              color == Colors.white
                  ? const TextStyle(color: Colors.white)
                  : TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showCreateListingSheet() {
    final cropController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    final locController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
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
              Text(
                "Create Harvest Listing",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              TextField(
                controller: cropController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Crop Name",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF54E167)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Quantity (e.g. 50 Quintals)",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF54E167)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Target Price (e.g. ৳3,100 / q)",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF54E167)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Mandi Location",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF54E167)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (cropController.text.isEmpty ||
                      qtyController.text.isEmpty ||
                      priceController.text.isEmpty) {
                    return;
                  }
                  setState(() {
                    _farmerListings.insert(0, {
                      'crop': cropController.text,
                      'demandedQty': qtyController.text,
                      'price': priceController.text,
                      'location':
                          locController.text.isEmpty
                              ? "Local Mandi"
                              : locController.text,
                      'buyerName': "Self Offer",
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Listing created successfully!"),
                      backgroundColor: Color(0xFF2CC04B),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF54E167),
                  foregroundColor: const Color(0xFF00390E),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Submit Listing",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExpertChatSheet(String expertName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chat with $expertName",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white10),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView(
                  children: [
                    _buildChatMessage(
                      sender: expertName,
                      text: "Hello Rihin! How is your crop growing?",
                      isUser: false,
                    ),
                    _buildChatMessage(
                      sender: "You",
                      text:
                          "Growing well, just testing the new NPK diagnostic tool.",
                      isUser: true,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Message sent to $expertName!")),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF54E167),
                      child: Icon(Icons.send, color: Color(0xFF00390E)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      body: Stack(
        children: [
          const _ParticleBackground(),

          // Body Content
          _buildBodyContent(),

          // Floating AI Button
          Positioned(
            right: 20,
            bottom: 110,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF54E167),
              onPressed: () => setState(() => _showAiPanel = true),
              child: const Icon(Icons.psychology, color: Color(0xFF00390E)),
            ),
          ),

          if (_showAiPanel) _buildAiSheet(),
        ],
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return AnimationLimiter(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 120),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildWeatherCard(),
                const SizedBox(height: 24),
                _buildActionHub(),
                const SizedBox(height: 24),
                _buildQuickSellCard(),
                const SizedBox(height: 24),
                _buildMarketInsights(),
                const SizedBox(height: 24),
                _buildExpertMarketplace(),
              ],
            ),
          ),
        );
      case 1:
        return _buildMarketPage();
      case 2:
        return _buildProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFF54E167),
          child: Icon(Icons.person, color: Color(0xFF00390E)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Rihin!",
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFBCCBB7),
              ),
            ),
            Text(
              "Krishinet",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF54E167),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return _GlassCard(
      borderRadius: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: Color(0xFFFFD54F), size: 36),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dhaka, BD",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "31°C • Humidity 74%",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFBCCBB7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF54E167).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF54E167).withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Soil Moisture",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "42% (Optimal)",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionHub() {
    return Row(
      children: [
        Expanded(
          child: _hubActionButton(
            label: "Soil Care",
            icon: Icons.grass,
            color: const Color(0xFF54E167),
            onTap: _showSoilCareSheet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _hubActionButton(
            label: "AI Diagnostic",
            icon: Icons.camera_alt,
            color: const Color(0xFF2CB04B),
            onTap: () => setState(() => _showAiPanel = true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _hubActionButton(
            label: "Direct Trade",
            icon: Icons.swap_horizontal_circle,
            color: const Color(0xFF81C784),
            onTap: () => setState(() => _selectedIndex = 1),
          ),
        ),
      ],
    );
  }

  Widget _hubActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSellCard() {
    return _GlassCard(
      borderColor: const Color(0xFF54E167).withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quick Sell Harvest",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  color: const Color(0xFF54E167),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.arrow_upward,
                color: Color(0xFF54E167),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "List your freshly harvested crops directly for local buyers in Bangladesh.",
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showCreateListingSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54E167),
                foregroundColor: const Color(0xFF00390E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                "Create New Listing",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsights() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Market Insights (Local)",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "View Trends",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF54E167),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _marketItem("Aman Rice", "৳2,850/q", "+4.2%")),
            const SizedBox(width: 12),
            Expanded(child: _marketItem("Yellow Corn", "৳1,920/q", "Stable")),
          ],
        ),
      ],
    );
  }

  Widget _marketItem(String title, String price, String change) {
    final bool isUp = change.startsWith("+");
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFBCCBB7),
                  fontSize: 13,
                ),
              ),
              if (change != "Stable")
                Text(
                  change,
                  style: GoogleFonts.plusJakartaSans(
                    color: isUp ? const Color(0xFF54E167) : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertMarketplace() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instant Expert Consultation",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _expertTile(
          name: "Dr. Aruna Singh",
          role: "Soil Health Specialist",
          isOnline: true,
        ),
        const SizedBox(height: 12),
        _expertTile(
          name: "Dr. Rafiqul Islam",
          role: "Pest Management Specialist",
          isOnline: false,
        ),
      ],
    );
  }

  Widget _expertTile({
    required String name,
    required String role,
    required bool isOnline,
  }) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                child: const Icon(Icons.person, color: Color(0xFFBCCBB7)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFF54E167) : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF122131),
                      width: 2,
                    ),
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
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFBCCBB7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF54E167),
            ),
            onPressed: () => _showExpertChatSheet(name),
          ),
        ],
      ),
    );
  }

  Widget _buildAiSheet() {
    return GestureDetector(
      onTap: () => setState(() => _showAiPanel = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {}, // Prevent tap events from closing the sheet
          child: Container(
            height: 450,
            decoration: const BoxDecoration(
              color: Color(0xFF122131),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              border: Border(
                top: BorderSide(color: Color(0xFF54E167), width: 1.5),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Handle/indicator line
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.psychology,
                            color: Color(0xFF54E167),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Krishi-AI Assistant",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => setState(() => _showAiPanel = false),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF273647), height: 1),
                // Chat Area
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildChatMessage(
                        sender: "Krishi-AI",
                        text:
                            "Assalamualikum Rihin! How can I help you with your agriculture options today?",
                        isUser: false,
                      ),
                      _buildChatMessage(
                        sender: "You",
                        text:
                            "What pesticide is best for yellow corn leaves turning brown?",
                        isUser: true,
                      ),
                      _buildChatMessage(
                        sender: "Krishi-AI",
                        text:
                            "It could be a signs of nitrogen deficiency or leaf blight. Let's do a soil check first or apply Neem oil pesticide.",
                        isUser: false,
                      ),
                    ],
                  ),
                ),
                // Input Row
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type message in Hindi/English...",
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            fillColor: const Color(0xFF0A1624),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF54E167),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF00390E),
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage({
    required String sender,
    required String text,
    required bool isUser,
  }) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: isUser ? const Color(0xFF54E167) : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color:
                isUser
                    ? const Color(0xFF2CC04B).withValues(alpha: 0.2)
                    : const Color(0xFF273647).withValues(alpha: 0.6),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 16),
            ),
            border: Border.all(
              color:
                  isUser
                      ? const Color(0xFF54E167).withValues(alpha: 0.3)
                      : const Color(0xFF273647),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: isUser ? const Color(0xFFE4FFE7) : Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMarketPage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 120),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Krishinet Market",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF54E167),
                  ),
                ),
                Text(
                  "Live buy/sell crop rates",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFBCCBB7),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _showCreateListingSheet,
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                "Create Offer",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
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
        const SizedBox(height: 20),
        // Search bar
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search wheat, rice, corn, potatoes...",
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            fillColor: Colors.white.withValues(alpha: 0.05),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Market Listings Headers
        Text(
          "Available Buyer Requests",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Listing items
        ..._farmerListings.map(
          (listing) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMarketListingCard(
              crop: listing['crop'] ?? "",
              demandedQty: listing['demandedQty'] ?? "",
              price: listing['price'] ?? "",
              location: listing['location'] ?? "",
              buyerName: listing['buyerName'] ?? "",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketListingCard({
    required String crop,
    required String demandedQty,
    required String price,
    required String location,
    required String buyerName,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                crop,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: const Color(0xFF54E167),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF54E167).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  price,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Volume Required: $demandedQty",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Spacer(),
              const Icon(Icons.business, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                buyerName,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF54E167),
                    side: const BorderSide(color: Color(0xFF54E167)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Bid Offer"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF54E167),
                    foregroundColor: const Color(0xFF00390E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Accept Direct"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 120),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF54E167),
                child: Icon(Icons.person, size: 50, color: Color(0xFF00390E)),
              ),
              const SizedBox(height: 16),
              Text(
                "Rihin",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "ID: KM-2026-8913",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFBCCBB7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF54E167).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF54E167),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Verified Farmer Partner",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF54E167),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Stats grid
        Row(
          children: [
            Expanded(
              child: _profileStatCard("Active Offers", "3", Icons.campaign),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _profileStatCard(
                "Total Earnings",
                "BDT 45,200",
                Icons.account_balance_wallet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Profile options list
        _profileOptionTile("My Farm Details & Crops", Icons.agriculture, () {}),
        const SizedBox(height: 12),
        _profileOptionTile("Transaction History", Icons.history, () {}),
        const SizedBox(height: 12),
        _profileOptionTile(
          "Krishinet Support Portal",
          Icons.support_agent,
          () {},
        ),
        const SizedBox(height: 12),
        _profileOptionTile("Settings & Language", Icons.settings, () {}),
        const SizedBox(height: 24),
        // Log out button
        ElevatedButton.icon(
          onPressed: () {
            // Navigate back (usually pop to ChoosePathScreen or login)
            Navigator.pop(context);
          },
          icon: const Icon(Icons.logout),
          label: const Text("Log Out"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5252).withValues(alpha: 0.2),
            foregroundColor: const Color(0xFFFF5252),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFFF5252)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF54E167), size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileOptionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFBCCBB7)),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      backgroundColor: const Color(0xFF122131),
      selectedItemColor: const Color(0xFF54E167),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: "Market",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

class _ParticleBackground extends StatefulWidget {
  const _ParticleBackground();
  @override
  State<_ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<_ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_DriftingParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Initialize 25 drifting particles
    for (int i = 0; i < 25; i++) {
      _particles.add(
        _DriftingParticle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 3 + 2,
          speed: _random.nextDouble() * 0.0015 + 0.0005,
          opacity: _random.nextDouble() * 0.35 + 0.05,
          swaySpeed: _random.nextDouble() * 1.5 + 0.5,
          swayWidth: _random.nextDouble() * 0.015 + 0.005,
        ),
      );
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() {
            _updateParticles();
          })
          ..repeat();
  }

  void _updateParticles() {
    for (var particle in _particles) {
      // Drifts upwards
      particle.y -= particle.speed;
      // Wrap around when particle moves off screen top
      if (particle.y < -0.05) {
        particle.y = 1.05;
        particle.x = _random.nextDouble();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(_particles, _controller.value),
      child: const SizedBox.expand(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _DriftingParticle {
  double x, y;
  final double size;
  final double speed;
  final double opacity;
  final double swaySpeed;
  final double swayWidth;

  _DriftingParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.swaySpeed,
    required this.swayWidth,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_DriftingParticle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      // Calculate sway offset using sine wave on animationValue
      final double sway =
          math.sin(animationValue * 2 * math.pi * p.swaySpeed) * p.swayWidth;
      final double drawX = (p.x + sway) * size.width;
      final double drawY = p.y * size.height;

      // Glow paint style
      final paint =
          Paint()
            ..color = const Color(0xFF54E167).withValues(alpha: p.opacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(drawX, drawY), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;

  const _GlassCard({
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF122131).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
