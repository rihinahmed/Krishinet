import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'widgets/knowledge_base_section.dart';

class FarmerDashboardScreen extends StatefulWidget {
  final bool isGuest;
  const FarmerDashboardScreen({super.key, this.isGuest = false});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  bool _showAiPanel = false;
  int _selectedIndex = 0;

  // Interactive Farm State
  String _farmLandSize = "3.5";
  String _farmPrimaryCrop = "Rice (BRRI-28)";
  String _soilPhValue = "6.2";
  String _lastSowedDate = "2026-06-15";

  int _selectedTrendCropIndex = 0;
  bool _hasNewAnnouncement = true;
  String _selectedChatFilter = 'All';
  String _marketSearchQuery = '';
  String _marketSortOption = 'none';
  final TextEditingController _marketSearchController = TextEditingController();

  bool _isAiTyping = false;
  final TextEditingController _aiController = TextEditingController();
  final List<String> _myCrops = ["Rice", "Wheat"];

  final List<Map<String, dynamic>> _appliedSubsidies = [
    {
      'id': 'SUB-2026-7821',
      'title': 'Boro Fertilizer Subsidy',
      'status': 'Pending Verification',
      'date': '2026-07-22',
      'details':
          'Application received at Upazila Agriculture Office. Local inspection pending.',
    },
    {
      'id': 'SUB-2026-6712',
      'title': 'Aman Seed Distribution Scheme',
      'status': 'Approved',
      'date': '2026-07-18',
      'details':
          'Approved by Department of Agricultural Extension. Collection code: ASD-8921.',
    },
  ];

  void _applyForSubsidy(String schemeTitle, String desc) {
    setState(() {
      _appliedSubsidies.insert(0, {
        'id': 'SUB-2026-${math.Random().nextInt(9000) + 1000}',
        'title': schemeTitle,
        'status': 'Processing',
        'date': DateTime.now().toString().split(' ')[0],
        'details':
            'Your application for "$schemeTitle" has been submitted successfully and is currently under processing by Upazila DAE officers.',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Successfully applied for $schemeTitle!"),
        backgroundColor: const Color(0xFF2CC04B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final List<Map<String, dynamic>> _govtNotices = [
    {
      'title': "Boro Crop Subsidy Notice",
      'message':
          "Government of Bangladesh announces an additional 20% fertilizer subsidy for Boro crop growers. Apply before end of this month.",
      'isRead': false,
    },
    {
      'title': "Heavy Rainfall Warning",
      'message':
          "Meteorological Department issues alert for heavy rain across Rajshahi and Bogura regions. Take precautions for harvested crops.",
      'isRead': false,
    },
  ];

  bool _checkGuestRestriction(String actionName) {
    if (widget.isGuest) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF122131),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.lock, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Guest Access Locked",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            content: Text(
              "To perform the action '$actionName', you must create a standard profile or log in with credentials.",
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFBCCBB7),
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF54E167),
                  foregroundColor: const Color(0xFF00390E),
                ),
                child: Text(
                  "Log In",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return true;
    }
    return false;
  }

  late final List<Map<String, dynamic>> _aiMessages = [
    {
      'sender': "Krishi-AI",
      'text':
          "Assalamu Alaikum Rihin! How can I help you with your agriculture options today?",
      'isUser': false,
    },
  ];

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _farmerListings = [
    {
      'crop': "Paddy Rice (Basmati)",
      'demandedQty': "5,000 kg",
      'price': "৳31 / kg",
      'location': "Bogura Mokam",
      'buyerName': "Bashar Traders",
      'buyerRating': "4.9",
      'date': "2026-07-23",
    },
    {
      'crop': "Wheat Grade A",
      'demandedQty': "10,000 kg",
      'price': "৳25 / kg",
      'location': "Rajshahi Bazar",
      'buyerName': "Desh Agritech",
      'buyerRating': "4.7",
      'date': "2026-07-22",
    },
    {
      'crop': "Potato Grade A",
      'demandedQty': "8,000 kg",
      'price': "৳15 / kg",
      'location': "Dhaka Sadarghat Hub",
      'buyerName': "Akij Agro Ltd",
      'buyerRating': "4.8",
      'date': "2026-07-21",
    },
    {
      'crop': "Potato Grade B",
      'demandedQty': "6,500 kg",
      'price': "৳12 / kg",
      'location': "Sherpur Bazar",
      'buyerName': "Desh Agritech",
      'buyerRating': "4.5",
      'date': "2026-07-20",
    },
  ];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-8921',
      'crop': 'Wheat Grade A',
      'qty': '2,500 kg',
      'price': '৳25 / kg',
      'buyer': 'Bashar Traders',
      'status': 'Processing',
      'date': '2026-07-22',
    },
    {
      'id': 'ORD-8812',
      'crop': 'Paddy Rice (Basmati)',
      'qty': '4,000 kg',
      'price': '৳31 / kg',
      'buyer': 'Desh Agritech',
      'status': 'Delivered',
      'date': '2026-07-18',
    },
  ];

  String _getCropImage(String cropName) {
    final name = cropName.toLowerCase();
    if (name.contains("rice") || name.contains("paddy")) {
      return 'assets/images/crop1.jpg';
    } else if (name.contains("potato") && name.contains("grade b")) {
      return 'assets/images/crop4.jpg';
    } else if (name.contains("potato") ||
        name.contains("jyoti") ||
        name.contains("grade a")) {
      return 'assets/images/crop2.jpg';
    } else if (name.contains("wheat")) {
      return 'assets/images/crop3.jpg';
    }
    return 'assets/images/plants.jpg';
  }

  void _showSoilCareSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.grass,
                        color: Color(0xFF54E167),
                        size: 28,
                      ),
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
                  const SizedBox(height: 24),
                  Text(
                    "Advisory for Registered Crops",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._myCrops.map((crop) => _buildCropAdvisoryCard(crop)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCropAdvisoryCard(String crop) {
    final bool isRice = crop.toLowerCase().contains("rice");
    final IconData icon = isRice ? Icons.spa : Icons.grass;
    final List<String> recommendations =
        isRice
            ? [
              "Apply 15-20 kg/ha of Muriate of Potash (MOP) to address potassium deficiency (72 kg/ha) during tillering.",
              "Humid weather (74% humidity) raises risk of Rice Blast. Spray Tricyclazole 75 WP at 0.6 g/L of water if blast lesions appear.",
              "Ensure standing water is kept at 2-5 cm, but adjust dynamically matching the weather forecast.",
            ]
            : [
              "Apply potash fertilizer prior to the booting stage to compensate for low soil potassium (72 kg/ha).",
              "High temperature (31°C) requires careful irrigation management. Schedule watering every 10-14 days.",
              "Use straw mulch to preserve soil moisture and protect roots from ambient heat stress.",
            ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF54E167), size: 20),
              const SizedBox(width: 8),
              Text(
                "$crop Care",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0, right: 8.0),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF54E167),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rec,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFBCCBB7),
                        fontSize: 12,
                      ),
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
    if (_checkGuestRestriction("Create Harvest Listing")) return;
    final cropController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    final villageController = TextEditingController();
    final thanaController = TextEditingController();
    final upazilaController = TextEditingController();
    final districtController = TextEditingController();
    final commentController = TextEditingController();
    String? selectedPaymentSystem;
    final List<String> selectedImages = [];
    final List<String> mockAvailableImages = [
      'assets/images/crop1.jpg',
      'assets/images/crop2.jpg',
      'assets/images/crop3.jpg',
      'assets/images/crop4.jpg',
      'assets/images/plants.jpg',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Create New Harvest Listing",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 16),

                    // Image Picker Section
                    Text(
                      "Crop Images (Add up to 5, at least 1 mandatory) *",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...selectedImages.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final path = entry.value;
                            return Stack(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -2,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setSheetState(() {
                                        selectedImages.removeAt(idx);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 9,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          if (selectedImages.length < 5)
                            GestureDetector(
                              onTap: () {
                                if (selectedImages.length <
                                    mockAvailableImages.length) {
                                  setSheetState(() {
                                    selectedImages.add(
                                      mockAvailableImages[selectedImages
                                          .length],
                                    );
                                  });
                                } else {
                                  setSheetState(() {
                                    selectedImages.add(mockAvailableImages[0]);
                                  });
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white24,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xFF54E167),
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Crop Name Input
                    TextField(
                      controller: cropController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Crop Name *",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quantity Input (in kg)
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Quantity (in kg) *",
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixText: "kg",
                        suffixStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price per kg Input
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Price per kg (৳) *",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixText: "৳ ",
                        prefixStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location Subfields
                    TextField(
                      controller: villageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Village *",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: thanaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Thana *",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: upazilaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Upazila *",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: districtController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "District *",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment System Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: selectedPaymentSystem,
                      dropdownColor: const Color(0xFF1F2E3D),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Payment System *",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                      items:
                          [
                                "Cash on Delivery",
                                "Bank Transfer",
                                "Mobile Banking (bKash/Nagad)",
                              ]
                              .map(
                                (val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setSheetState(() {
                          selectedPaymentSystem = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Comment (Optional) Input
                    TextField(
                      controller: commentController,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Comments / Special Instructions (Optional)",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF54E167)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (selectedImages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please add at least 1 crop image.",
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        if (cropController.text.trim().isEmpty ||
                            qtyController.text.trim().isEmpty ||
                            priceController.text.trim().isEmpty ||
                            villageController.text.trim().isEmpty ||
                            thanaController.text.trim().isEmpty ||
                            upazilaController.text.trim().isEmpty ||
                            districtController.text.trim().isEmpty ||
                            selectedPaymentSystem == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill in all mandatory fields (*).",
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _farmerListings.insert(0, {
                            'crop': cropController.text.trim(),
                            'demandedQty': "${qtyController.text.trim()} kg",
                            'price': "৳${priceController.text.trim()} / kg",
                            'location':
                                "${villageController.text.trim()}, ${thanaController.text.trim()}, ${upazilaController.text.trim()}, ${districtController.text.trim()}",
                            'buyerName': "Self Offer",
                            'buyerRating': "5.0",
                            'date': DateTime.now().toString().split(' ')[0],
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
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Submit Listing",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showExpertChatSheet(String expertName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpertChatScreen(expertName: expertName),
      ),
    );
  }

  void _showTrendsSheet() {
    final List<Map<String, dynamic>> trendCrops = [
      {
        'name': 'Aman Rice',
        'prices': [26.0, 27.0, 26.5, 28.0, 28.5, 29.2],
        'soldQty': [12000.0, 15000.0, 14200.0, 18500.0, 21000.0, 24500.0],
        'months': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        'change': '+4.2%',
        'forecast': '৳30 / kg',
        'peak': '৳29.20',
        'avg': '৳27.53',
      },
      {
        'name': 'Yellow Corn',
        'prices': [18.0, 18.5, 19.0, 18.8, 19.2, 19.5],
        'soldQty': [8500.0, 9200.0, 11000.0, 10500.0, 13000.0, 14500.0],
        'months': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        'change': '+1.6%',
        'forecast': '৳19.80 / kg',
        'peak': '৳19.50',
        'avg': '৳18.83',
      },
      {
        'name': 'Basmati Rice',
        'prices': [30.0, 30.5, 31.0, 30.8, 31.2, 32.0],
        'soldQty': [5000.0, 5500.0, 6200.0, 5800.0, 7000.0, 8500.0],
        'months': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        'change': '+6.7%',
        'forecast': '৳32.80 / kg',
        'peak': '৳32.00',
        'avg': '৳30.91',
      },
      {
        'name': 'Wheat Grade A',
        'prices': [22.0, 22.5, 23.0, 23.5, 24.0, 24.5],
        'soldQty': [15000.0, 16500.0, 18000.0, 17200.0, 19500.0, 22000.0],
        'months': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        'change': '+11.3%',
        'forecast': '৳25.00 / kg',
        'peak': '৳24.50',
        'avg': '৳23.25',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                final crop = trendCrops[_selectedTrendCropIndex];
                final List<double> prices = List<double>.from(crop['prices']);
                final List<String> months = List<String>.from(crop['months']);
                final List<double> soldQty = List<double>.from(crop['soldQty']);

                // Calculate sold stats
                final double totalSold = soldQty.reduce((a, b) => a + b);
                final double maxSold = soldQty.reduce((a, b) => a > b ? a : b);
                final int maxSoldIndex = soldQty.indexOf(maxSold);
                final String peakMonth = months[maxSoldIndex];
                final double avgSold = totalSold / soldQty.length;

                String formatQty(double val) {
                  if (val >= 1000) {
                    double kVal = val / 1000;
                    return "${kVal.toStringAsFixed(kVal == kVal.toInt() ? 0 : 1)}k kg";
                  }
                  return "${val.toStringAsFixed(0)} kg";
                }

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Market & Sales Insights",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Autonomous price forecasting & historical volume analysis",
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFBCCBB7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(trendCrops.length, (index) {
                            final isSelected = _selectedTrendCropIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  trendCrops[index]['name'],
                                  style: GoogleFonts.plusJakartaSans(
                                    color:
                                        isSelected
                                            ? const Color(0xFF00390E)
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: const Color(0xFF54E167),
                                backgroundColor: const Color(0xFF1F2E3D),
                                onSelected: (selected) {
                                  if (selected) {
                                    setSheetState(() {
                                      _selectedTrendCropIndex = index;
                                    });
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Market Price Trend (৳/kg)",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 150,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomPaint(
                          painter: TrendsChartPainter(
                            prices: prices,
                            months: months,
                            lineColor: const Color(0xFF54E167),
                            textColor: const Color(0xFFBCCBB7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatBox(
                            "Peak Price",
                            crop['peak'],
                            Icons.trending_up,
                            Colors.greenAccent,
                          ),
                          _buildStatBox(
                            "Average",
                            crop['avg'],
                            Icons.analytics,
                            Colors.blueAccent,
                          ),
                          _buildStatBox(
                            "Autonomous Forecast",
                            crop['forecast'],
                            Icons.online_prediction,
                            const Color(0xFF54E167),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Overall Quantity Sold Trend (Monthly)",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 150,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomPaint(
                          painter: SoldChartPainter(
                            quantities: soldQty,
                            months: months,
                            lineColor: Colors.blueAccent,
                            textColor: const Color(0xFFBCCBB7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatBox(
                            "Total Sold",
                            formatQty(totalSold),
                            Icons.shopping_bag,
                            Colors.blueAccent,
                          ),
                          _buildStatBox(
                            "Peak Month",
                            "$peakMonth (${formatQty(maxSold)})",
                            Icons.insights,
                            Colors.purpleAccent,
                          ),
                          _buildStatBox(
                            "Average/Mo",
                            formatQty(avgSold),
                            Icons.bar_chart,
                            Colors.amberAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2E3D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFBCCBB7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
              child: const Icon(Icons.assistant, color: Color(0xFF00390E)),
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
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 120),
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
                _buildEmergencyAlerts(),
                const SizedBox(height: 24),
                _buildQuickSellCard(),
                const SizedBox(height: 24),
                _buildRunningOrderUpdate(),
                const SizedBox(height: 24),
                _buildYieldSummaryCard(),
                const SizedBox(height: 24),
                _buildAppliedSubsidiesStatus(),
                const SizedBox(height: 24),
                _buildUpcomingTrainings(),
                const SizedBox(height: 24),
                _buildTopBuyers(),
                const SizedBox(height: 24),
                _buildMarketInsights(),
                const SizedBox(height: 24),
                _buildKrishiNews(),
                const SizedBox(height: 24),
                _buildDailyAdvisories(),
                const SizedBox(height: 24),
                const KnowledgeBaseSection(role: 'farmer'),
              ],
            ),
          ),
        );
      case 1:
        return _buildMarketPage();
      case 2:
        return _buildOrdersPage();
      case 3:
        return _buildChatsPage();
      case 4:
        return _buildProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChatsPage() {
    if (widget.isGuest) {
      return Scaffold(
        backgroundColor: const Color(0xFF051424),
        appBar: AppBar(
          backgroundColor: const Color(0xFF122131),
          title: Text(
            "Conversations",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _GlassCard(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.forum_outlined,
                    color: Color(0xFF54E167),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Chats are locked for Guests",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "In order to view recent conversations and communicate with verified buyers or agricultural specialists, please sign in.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFBCCBB7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54E167),
                      foregroundColor: const Color(0xFF00390E),
                      minimumSize: const Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Log In Now",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

    final List<Map<String, String>> chatItems = [
      {
        'name': "Dr. Dilruba Khanam",
        'role': "Soil Health Specialist",
        'message': "Please apply the MOP fertilizer before next week.",
        'time': "10:30 AM",
        'unread': "1",
        'category': "Vet",
      },
      {
        'name': "Dr. Rafiqul Islam",
        'role': "Pest Specialist",
        'message': "Neem bio-fungicide is recommended.",
        'time': "July 22",
        'unread': "0",
        'category': "Vet",
      },
      {
        'name': "Bashar Traders",
        'role': "Rice Buyer",
        'message': "What is your target price per kg for Basmati Rice?",
        'time': "Yesterday",
        'unread': "0",
        'category': "Buyer",
      },
      {
        'name': "Bhuiyan Cold Storage",
        'role': "Storage Partner",
        'message': "Space is available for potato storage.",
        'time': "2 days ago",
        'unread': "0",
        'category': "Buyer",
      },
      {
        'name': "Upazila Agri Office",
        'role': "Govt Officer",
        'message': "Your Boro fertilizer subsidy has been approved.",
        'time': "3 days ago",
        'unread': "0",
        'category': "Govt",
      },
      {
        'name': "Rajshahi Bazar Rep",
        'role': "Govt Price Checker",
        'message': "Price of jute is trending upwards today.",
        'time': "July 20",
        'unread': "0",
        'category': "Govt",
      },
    ];

    final filteredChats =
        _selectedChatFilter == 'All'
            ? chatItems
            : chatItems
                .where((c) => c['category'] == _selectedChatFilter)
                .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      appBar: AppBar(
        backgroundColor: const Color(0xFF122131),
        title: Text(
          "Conversations",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFF122131),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    ['All', 'Vet', 'Govt', 'Buyer'].map((filter) {
                      final isSelected = _selectedChatFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            filter == 'Vet' ? 'Vet/Specialist' : filter,
                            style: GoogleFonts.plusJakartaSans(
                              color:
                                  isSelected
                                      ? const Color(0xFF00390E)
                                      : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF54E167),
                          backgroundColor: const Color(0xFF1F2E3D),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedChatFilter = filter;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          Expanded(
            child:
                filteredChats.isEmpty
                    ? Center(
                      child: Text(
                        "No conversations in this filter.",
                        style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredChats.length,
                      separatorBuilder:
                          (context, index) =>
                              const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (context, index) {
                        final item = filteredChats[index];
                        final bool isUnread = item['unread'] != "0";
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(
                              0xFF54E167,
                            ).withValues(alpha: 0.15),
                            child: Text(
                              item['name']![0],
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF54E167),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['name']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                item['time']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['message']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color:
                                          isUnread
                                              ? Colors.white
                                              : const Color(0xFFBCCBB7),
                                      fontSize: 13,
                                      fontWeight:
                                          isUnread
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isUnread)
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF54E167),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      item['unread']!,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF00390E),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _showExpertChatSheet(item['name']!);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny, color: Color(0xFFFFD54F), size: 36),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dhaka, Bangladesh",
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
          const SizedBox(height: 16),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 16),
          Text(
            "7-Day Weather Forecast",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildForecastDay(
                  "Thu",
                  Icons.wb_sunny,
                  "32°",
                  "26°",
                  const Color(0xFFFFD54F),
                ),
                _buildForecastDay(
                  "Fri",
                  Icons.cloud,
                  "31°",
                  "25°",
                  Colors.grey,
                ),
                _buildForecastDay(
                  "Sat",
                  Icons.thunderstorm,
                  "29°",
                  "24°",
                  Colors.blue,
                ),
                _buildForecastDay(
                  "Sun",
                  Icons.thunderstorm,
                  "28°",
                  "24°",
                  Colors.blue,
                ),
                _buildForecastDay(
                  "Mon",
                  Icons.cloud,
                  "31°",
                  "25°",
                  Colors.grey,
                ),
                _buildForecastDay(
                  "Tue",
                  Icons.wb_sunny,
                  "33°",
                  "26°",
                  const Color(0xFFFFD54F),
                ),
                _buildForecastDay(
                  "Wed",
                  Icons.wb_sunny,
                  "32°",
                  "25°",
                  const Color(0xFFFFD54F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastDay(
    String day,
    IconData icon,
    String maxTemp,
    String minTemp,
    Color iconColor,
  ) {
    return Container(
      width: 55,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 6),
          Text(
            maxTemp,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            minTemp,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 10,
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
            label: "Experts Near Me",
            icon: Icons.people,
            color: const Color(0xFF2CB04B),
            onTap: () {
              if (_checkGuestRestriction("Experts Near Me")) return;
              _showExpertsNearMeSheet();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _hubActionButton(
            label: "Announcements\n& Schemes",
            icon: Icons.campaign,
            color: const Color(0xFF81C784),
            showBadge: _hasNewAnnouncement,
            onTap: () {
              setState(() {
                _hasNewAnnouncement = false;
              });
              _showAnnouncementsSchemesSheet();
            },
          ),
        ),
      ],
    );
  }

  void _showExpertsNearMeSheet() {
    final List<Map<String, dynamic>> localExperts = [
      {
        'name': "Dr. Dilruba Khanam",
        'role': "Soil Health Specialist",
        'distance': "1.2 km away",
        'rating': 4.9,
        'online': true,
      },
      {
        'name': "Dr. Rafiqul Islam",
        'role': "Pest Control Specialist",
        'distance': "2.5 km away",
        'rating': 4.8,
        'online': true,
      },
      {
        'name': "Prof. Abu Bakr",
        'role': "Veterinary Surgeon",
        'distance': "4.1 km away",
        'rating': 4.7,
        'online': false,
      },
      {
        'name': "Engineer M. Rahman",
        'role': "Irrigation Specialist",
        'distance': "5.0 km away",
        'rating': 4.6,
        'online': true,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Color(0xFF54E167),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Experts Near You",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Consult verified agricultural specialists in your local upazila",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFBCCBB7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: localExperts.length,
                      itemBuilder: (context, index) {
                        final exp = localExperts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(
                                      0xFF54E167,
                                    ).withValues(alpha: 0.15),
                                    child: Text(
                                      exp['name'][0],
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF54E167),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color:
                                            exp['online']
                                                ? const Color(0xFF54E167)
                                                : Colors.grey,
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
                                      exp['name'],
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      exp['role'],
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFBCCBB7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          "${exp['rating']}",
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.amber,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          exp['distance'],
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Color(0xFF54E167),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showCallSimulator(exp['name']);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chat,
                                      color: Color(0xFF54E167),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showExpertChatSheet(exp['name']);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
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

  void _showNoticeDetailsDialog(Map<String, dynamic> notice) {
    final title = notice['title'] ?? "";
    final isAlreadyApplied = _appliedSubsidies.any(
      (sub) => sub['title'] == title,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2E3D),
          title: Text(
            notice['title'],
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            notice['message'],
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 14,
            ),
          ),
          actions: [
            if (!isAlreadyApplied && title.toLowerCase().contains("subsidy"))
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyForSubsidy(title, notice['message'] ?? "");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF54E167),
                  foregroundColor: const Color(0xFF00390E),
                ),
                child: const Text("Apply for Subsidy"),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF54E167),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAnnouncementsSchemesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF122131),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.campaign,
                                color: Color(0xFF81C784),
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Announcements & Schemes",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),

                      // Section 1: Government Notices
                      Text(
                        "Official Government Notices",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF81C784),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._govtNotices.map((notice) {
                        final bool isRead = notice['isRead'] ?? false;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                                isRead
                                    ? Colors.white.withValues(alpha: 0.01)
                                    : const Color(
                                      0xFF81C784,
                                    ).withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isRead
                                      ? Colors.white10
                                      : const Color(
                                        0xFF81C784,
                                      ).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notice['title'],
                                      style: GoogleFonts.plusJakartaSans(
                                        color:
                                            isRead ? Colors.grey : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        decoration:
                                            isRead
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                  ),
                                  if (!isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                notice['message'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color:
                                      isRead
                                          ? Colors.grey
                                          : const Color(0xFFBCCBB7),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!isRead) ...[
                                    TextButton(
                                      onPressed: () {
                                        setSheetState(() {
                                          notice['isRead'] = true;
                                        });
                                        setState(
                                          () {},
                                        ); // sync outer red dot state
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "Mark as read",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF54E167),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  TextButton(
                                    onPressed: () {
                                      _showNoticeDetailsDialog(notice);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      "View details",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),

                      // Section 2: Subsidies & Schemes
                      Text(
                        "Active Subsidies & Schemes",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF81C784),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSchemeCard(
                        title: "Aus & Aman Paddy Incentive",
                        description:
                            "Free high-yield crop seeds and chemical fertilizers (Urea, DAP, MOP) distributed to marginal farmers.",
                        status: "Apply Now",
                        contact: "Upazila Agriculture Office",
                      ),
                      _buildSchemeCard(
                        title: "Special Krishi Card Loan (4% Interest)",
                        description:
                            "Low-interest credit lines for crop production, accessible through Krishi Bank & Sonali Bank.",
                        status: "Active",
                        contact: "Local Bank Branch",
                      ),
                      _buildSchemeCard(
                        title: "Agricultural Machinery Subsidy (50-70%)",
                        description:
                            "Subsidized distribution of power tillers, combined harvesters, and water pumps.",
                        status: "Ongoing",
                        contact: "DAE Agricultural Engineer",
                      ),
                      _buildSchemeCard(
                        title: "Irrigation & Diesel Rebate Scheme",
                        description:
                            "Direct 20% electricity tariff discount for electric pumps and cash rebate for diesel fuel costs.",
                        status: "Apply Now",
                        contact: "Union Parishad Secretariat",
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSchemeCard({
    required String title,
    required String description,
    required String status,
    required String contact,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF54E167).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.grey, size: 14),
              const SizedBox(width: 4),
              Text(
                "Contact: $contact",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (status == "Apply Now")
                TextButton(
                  onPressed: () {
                    if (_checkGuestRestriction("Apply for Govt Schemes")) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Application submitted successfully for: $title",
                        ),
                        backgroundColor: const Color(0xFF2CC04B),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    "Apply",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF54E167),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hubActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 28),
                if (showBadge)
                  Positioned(
                    right: -2,
                    top: -2,
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add, size: 22),
        label: Text(
          "Create New Harvest Listing",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: _showCreateListingSheet,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF54E167),
          foregroundColor: const Color(0xFF00390E),
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF54E167).withValues(alpha: 0.25),
        ),
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
              onTap: _showTrendsSheet,
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
            Expanded(child: _marketItem("Aman Rice", "৳28.50/kg", "+4.2%")),
            const SizedBox(width: 12),
            Expanded(child: _marketItem("Yellow Corn", "৳19.20/kg", "Stable")),
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

  Widget _buildYieldSummaryCard() {
    final List<Map<String, dynamic>> yields = [
      {
        'crop': 'Aman Rice',
        'season': 'Kharif-2 2025',
        'qty': '4,850 kg',
        'avgPrice': '৳31 / kg',
        'revenue': '৳150,350',
      },
      {
        'crop': 'Boro Rice',
        'season': 'Rabi 2024-25',
        'qty': '5,200 kg',
        'avgPrice': '৳29.2 / kg',
        'revenue': '৳151,840',
      },
      {
        'crop': 'Wheat (BARI-33)',
        'season': 'Rabi 2024-25',
        'qty': '3,400 kg',
        'avgPrice': '৳25 / kg',
        'revenue': '৳85,000',
      },
      {
        'crop': 'Potato Grade A',
        'season': 'Winter 2024',
        'qty': '6,000 kg',
        'avgPrice': '৳18 / kg',
        'revenue': '৳108,000',
      },
      {
        'crop': 'Maize (Yellow)',
        'season': 'Summer 2024',
        'qty': '7,200 kg',
        'avgPrice': '৳22 / kg',
        'revenue': '৳158,400',
      },
    ];

    Widget buildYieldItem(Map<String, dynamic> yld, bool showDivider) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    yld['crop'],
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    yld['season'],
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    yld['qty'],
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF54E167),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Avg: ${yld['avgPrice']}",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFBCCBB7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Revenue Achieved:",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              Text(
                yld['revenue'],
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white10, height: 1),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Yield Summary",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "My Yield Summary",
                          items:
                              yields
                                  .map(
                                    (yld) => _GlassCard(
                                      borderRadius: 16,
                                      padding: const EdgeInsets.all(16),
                                      child: buildYieldItem(yld, false),
                                    ),
                                  )
                                  .toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        _GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ...yields.take(2).map((yld) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: buildYieldItem(yld, yld != yields[1]),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppliedSubsidiesStatus() {
    Widget buildSubsidyCard(Map<String, dynamic> sub) {
      Color statusColor = Colors.amber;
      if (sub['status'] == 'Approved') statusColor = const Color(0xFF54E167);
      if (sub['status'] == 'Rejected') statusColor = Colors.redAccent;

      return GestureDetector(
        onTap: () => _showSubsidyDetailsDialog(sub),
        child: _GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      sub['title'],
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sub['status'],
                      style: GoogleFonts.plusJakartaSans(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "ID: ${sub['id']}",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Applied: ${sub['date']}",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFBCCBB7),
                      fontSize: 11,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Applied Subsidies Status",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "Applied Subsidies Status",
                          items:
                              _appliedSubsidies
                                  .map((sub) => buildSubsidyCard(sub))
                                  .toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_appliedSubsidies.isEmpty)
          _GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Center(
              child: Text(
                "No applied subsidies. Check announcements to apply.",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _appliedSubsidies.take(2).map((sub) {
                    return Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 12),
                      child: buildSubsidyCard(sub),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  void _showSubsidyDetailsDialog(Map<String, dynamic> sub) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF122131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            sub['title'],
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Application ID", sub['id']),
              _buildDetailRow("Date Applied", sub['date']),
              _buildDetailRow("Current Status", sub['status']),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              Text(
                "DAE Officer Comments:",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                sub['details'] ?? "No comments available yet.",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF54E167),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmergencyAlerts() {
    final List<Map<String, dynamic>> alerts = [
      {
        'title': "High Humidity Warning",
        'message':
            "Relative humidity is currently 74% in Dhaka division, creating optimal conditions for leaf blast. Inspect paddy fields immediately.",
        'severity': 'high',
      },
      {
        'title': "Flash Flood Warning",
        'message':
            "Water levels rising in northern Bogura rivers. Harvest mature crops before tomorrow evening.",
        'severity': 'critical',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Emergency Alerts",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...alerts.map((alert) {
          final isCritical = alert['severity'] == 'critical';
          final bannerColor =
              isCritical ? Colors.redAccent : Colors.orangeAccent;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bannerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bannerColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isCritical ? Icons.warning_amber_rounded : Icons.info_outline,
                  color: bannerColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'],
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert['message'],
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFBCCBB7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOrderTrackerItem(Map<String, dynamic> ord) {
    Color badgeColor = Colors.amber;
    if (ord['status'] == 'In Transit') badgeColor = Colors.blueAccent;
    if (ord['status'] == 'Bid Pending') badgeColor = Colors.purpleAccent;

    return InkWell(
      onTap: () => _showOrderDetailsSheet(context, ord),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: badgeColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ord['crop'],
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Buyer: ${ord['buyer']}",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ord['status'],
                    style: GoogleFonts.plusJakartaSans(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunningOrderUpdate() {
    final activeOrders =
        _orders
            .where(
              (o) => o['status'] != 'Delivered' && o['status'] != 'Completed',
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Active Orders Tracker",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "Active Orders Tracker",
                          items:
                              activeOrders
                                  .map(
                                    (ord) => _GlassCard(
                                      borderRadius: 16,
                                      padding: const EdgeInsets.all(16),
                                      child: _buildOrderTrackerItem(ord),
                                    ),
                                  )
                                  .toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        _GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (activeOrders.isEmpty)
                Center(
                  child: Text(
                    "No active orders currently running.",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                ...activeOrders.take(2).map((ord) {
                  return _buildOrderTrackerItem(ord);
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTrainings() {
    final List<Map<String, dynamic>> workshops = [
      {
        'title': "Boro Crop Modern Harvesting",
        'date': "July 26, 2026 • 10:00 AM",
        'location': "DAE Bogura Sub-Center",
        'instructor': "Dr. Rafiqul Islam",
      },
      {
        'title': "Soil Health & Urea Balancing",
        'date': "August 02, 2026 • 09:30 AM",
        'location': "Upazila Agriculture Hall",
        'instructor': "Dr. Dilruba Khanam",
      },
      {
        'title': "Pest Control & Organic Pesticides",
        'date': "August 10, 2026 • 03:00 PM",
        'location': "Union Digital Center",
        'instructor': "Dr. Rafiqul Islam",
      },
      {
        'title': "Drip Irrigation Best Practices",
        'date': "August 15, 2026 • 11:00 AM",
        'location': "Online Webinar",
        'instructor': "Engineer M. Rahman",
      },
    ];

    Widget buildWorkshopCard(Map<String, dynamic> workshop) {
      return _GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workshop['title'],
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  workshop['date'],
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFBCCBB7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    workshop['location'],
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "By: ${workshop['instructor']}",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Registered successfully! Check your email for joining instructions.",
                        ),
                        backgroundColor: Color(0xFF2CC04B),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF54E167,
                    ).withValues(alpha: 0.2),
                    foregroundColor: const Color(0xFF54E167),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    minimumSize: const Size(60, 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Workshops & Training",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "Workshops & Training",
                          items:
                              workshops
                                  .map((w) => buildWorkshopCard(w))
                                  .toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                workshops.take(2).map((workshop) {
                  return Container(
                    width: 260,
                    margin: const EdgeInsets.only(right: 12),
                    child: buildWorkshopCard(workshop),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvisoryItem(Map<String, dynamic> adv) {
    return InkWell(
      onTap: () => _showAdvisoryDetailsSheet(context, adv),
      child: _GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  adv['icon'] as IconData,
                  color: const Color(0xFF54E167),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    adv['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              adv['desc'] as String,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFBCCBB7),
                fontSize: 12,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyAdvisories() {
    final List<Map<String, dynamic>> advisories = [
      {
        'icon': Icons.opacity,
        'title': "Water Retention Alert",
        'desc':
            "Maintain 2-5 cm of standing water in paddy fields; do not allow completely dry cracks during tillering.",
      },
      {
        'icon': Icons.science,
        'title': "Potassium Top-dress",
        'desc':
            "Since soil potassium is low (72 kg/ha), apply 15 kg of MOP fertilizer per acre before heading.",
      },
      {
        'icon': Icons.bug_report,
        'title': "Pest Patrol Warning",
        'desc':
            "Keep a lookout for Rice Blast lesions under the current high humidity (74%). Spray organic neem bio-fungicides if seen.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Daily Krishi Advisories",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "Daily Krishi Advisories",
                          items:
                              advisories
                                  .map((adv) => _buildAdvisoryItem(adv))
                                  .toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                advisories.take(2).map((adv) {
                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildAdvisoryItem(adv),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildKrishiNews() {
    final List<Map<String, String>> news = [
      {
        'title': "BADC distributes Aman seeds in Bogura district",
        'source': "Daily Krishi News",
        'time': "4 hours ago",
      },
      {
        'title':
            "Organic farming gains massive popularity in Mymensingh division",
        'source': "Ecosystem Blog",
        'time': "Yesterday",
      },
      {
        'title':
            "Upazila Agriculture Office organizes free soil testing sessions next Monday",
        'source': "DAE Notice",
        'time': "2 days ago",
      },
      {
        'title': "Rice blast infestation contained in northern districts",
        'source': "Wheat & Rice Hub",
        'time': "3 days ago",
      },
      {
        'title':
            "Government increases agriculture machinery import incentives by 15%",
        'source': "National Finance Notice",
        'time': "5 days ago",
      },
    ];

    Widget buildNewsItem(Map<String, String> item) {
      return _GlassCard(
        borderRadius: 12,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF54E167).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.newspaper,
                color: Color(0xFF54E167),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['source']!,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFBCCBB7),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        item['time']!,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey,
                          fontSize: 10,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Agricultural News & Events",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "Krishi News",
                          items:
                              news.map((item) => buildNewsItem(item)).toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...news.take(2).map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: buildNewsItem(item),
          );
        }),
      ],
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
            height: 480,
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
                          const Icon(Icons.assistant, color: Color(0xFF54E167)),
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
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _aiMessages.length + (_isAiTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _aiMessages.length) {
                        return _buildTypingIndicator();
                      }
                      final msg = _aiMessages[index];
                      return _buildChatMessage(
                        sender: msg['sender'] ?? "",
                        text: msg['text'] ?? "",
                        isUser: msg['isUser'] ?? false,
                        localAsset: msg['localAsset'],
                      );
                    },
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
                      IconButton(
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          color: Color(0xFF54E167),
                          size: 26,
                        ),
                        onPressed: _showImagePickerDialog,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _aiController,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (val) => _sendTextMessage(val),
                          decoration: InputDecoration(
                            hintText: "Type message in Bangla/English...",
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
                          onPressed: () => _sendTextMessage(_aiController.text),
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

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2E3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Crop Image for Diagnosis",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.spa, color: Color(0xFF54E167)),
                title: Text(
                  "Rice Leaf (Check for Rice Blast)",
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _sendMockImage(
                    assetPath: 'assets/images/crop1.jpg',
                    cropName: "Rice Leaf",
                    diseaseName: "Rice Blast (Magnaporthe oryzae)",
                    solution:
                        """Thesis-Proven Treatment:
• Apply Tricyclazole 75 WP at 0.6 g/L of water.
• Use silica-rich fertilizers to strengthen cell walls.
• Keep field drainage optimal to reduce leaf wetness.""",
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle_outlined, color: Colors.amber),
                title: Text(
                  "Potato Leaf (Check for Late Blight)",
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _sendMockImage(
                    assetPath: 'assets/images/crop2.jpg',
                    cropName: "Potato Leaf",
                    diseaseName: "Late Blight (Phytophthora infestans)",
                    solution:
                        """Research-Backed Treatment:
• Spray Mancozeb (2 g/L) or Metalaxyl + Mancozeb (2 g/L) immediately.
• Use disease-free certified seeds/tubers.
• Remove and destroy infected foliage.""",
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_enhance, color: Colors.blue),
                title: Text(
                  "Capture Custom Photo (Other Crop)",
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _sendMockImage(
                    assetPath: 'assets/images/crop3.jpg',
                    cropName: "Custom Crop",
                    diseaseName: "Unrecognized / Regional Strain",
                    solution:
                        """Diagnosis Unavailable:
• Disease detection for this crop is currently undergoing regional research validation in Bangladesh.
• Recommended action: Please consult our live agronomist or veterinary doctor in the Expert Marketplace for manual validation.""",
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMockImage({
    required String assetPath,
    required String cropName,
    required String diseaseName,
    required String solution,
  }) {
    setState(() {
      _aiMessages.add({
        'sender': 'You',
        'text': "Uploaded $cropName photo for diagnosis.",
        'isUser': true,
        'localAsset': assetPath,
      });
      _isAiTyping = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isAiTyping = false;
          _aiMessages.add({
            'sender': 'Krishi-AI',
            'text':
                """Diagnosis Report:

Target Crop: $cropName
Detected Issue: $diseaseName

$solution""",
            'isUser': false,
          });
        });
      }
    });
  }

  void _sendTextMessage(String text) {
    if (text.trim().isEmpty) return;
    _aiController.clear();
    setState(() {
      _aiMessages.add({'sender': 'You', 'text': text, 'isUser': true});
      _isAiTyping = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isAiTyping = false;
          String response =
              "Thank you for the message. For pest control and soil health in Bangladesh, we recommend checking your active Soil Care diagnostics or consulting our online experts like Dr. Dilruba Khanam.";
          if (text.toLowerCase().contains("weather")) {
            response =
                "The forecast in Dhaka shows hot and humid conditions (31°C) with occasional showers over the next 7 days. Be sure to check the detailed forecast card on your dashboard.";
          } else if (text.toLowerCase().contains("crop") ||
              text.toLowerCase().contains("rice")) {
            response =
                "For Aman and Boro rice in Bangladesh, ensure proper nitrogen application and check for early leaf blast indicators, especially in humid conditions.";
          }
          _aiMessages.add({
            'sender': 'Krishi-AI',
            'text': response,
            'isUser': false,
          });
        });
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Krishi-AI",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF273647).withValues(alpha: 0.6),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0xFF273647)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF54E167),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Analyzing...",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage({
    required String sender,
    required String text,
    required bool isUser,
    String? localAsset,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (localAsset != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    localAsset,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  color: isUser ? const Color(0xFFE4FFE7) : Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _showBidOfferDialog(Map<String, String> listing) {
    final priceStr = listing['price']!.replaceAll(RegExp(r'[^0-9]'), '');
    final qtyStr = listing['demandedQty']!.replaceAll(RegExp(r'[^0-9]'), '');

    final priceController = TextEditingController(text: priceStr);
    final qtyController = TextEditingController(text: qtyStr);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF122131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Bid for ${listing['crop']}",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buyer's Offer: ${listing['price']} | Required: ${listing['demandedQty']}",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFBCCBB7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Your Bid Price (৳ / kg) *",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter bid price per kg",
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Your Supply Quantity (kg) *",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter quantity in kg",
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final bidPrice = priceController.text.trim();
                final bidQty = qtyController.text.trim();
                if (bidPrice.isEmpty || bidQty.isEmpty) return;

                setState(() {
                  _orders.insert(0, {
                    'id': 'BID-${math.Random().nextInt(9000) + 1000}',
                    'crop': listing['crop'] ?? "",
                    'qty': "$bidQty kg",
                    'price': "৳$bidPrice / kg",
                    'buyer': listing['buyerName'] ?? "Unknown Buyer",
                    'status': 'Bid Pending',
                    'date': DateTime.now().toString().split(' ')[0],
                  });
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Bid of ৳$bidPrice/kg submitted successfully!",
                    ),
                    backgroundColor: const Color(0xFF2CC04B),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54E167),
                foregroundColor: const Color(0xFF00390E),
              ),
              child: Text(
                "Submit Bid",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _acceptDirectListing(Map<String, String> listing) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF122131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Accept Buyer Request?",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "You are agreeing to sell ${listing['demandedQty']} of ${listing['crop']} at ${listing['price']} to ${listing['buyerName']}.",
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _orders.insert(0, {
                    'id': 'ORD-${math.Random().nextInt(9000) + 1000}',
                    'crop': listing['crop'] ?? "",
                    'qty': listing['demandedQty'] ?? "",
                    'price': listing['price'] ?? "",
                    'buyer': listing['buyerName'] ?? "Unknown Buyer",
                    'status': 'Processing',
                    'date': DateTime.now().toString().split(' ')[0],
                  });
                  _farmerListings.remove(listing);
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Request accepted! Order created in the Orders tab.",
                    ),
                    backgroundColor: Color(0xFF2CC04B),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54E167),
                foregroundColor: const Color(0xFF00390E),
              ),
              child: Text(
                "Accept",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBuyers() {
    final List<Map<String, dynamic>> topBuyers = [
      {
        'name': "Bashar Traders",
        'rating': 4.9,
        'boughtAmt': "145k kg",
        'preferred': "Paddy Rice, Wheat",
        'verified': true,
      },
      {
        'name': "Akij Food & Beverage",
        'rating': 4.8,
        'boughtAmt': "310k kg",
        'preferred': "Potatoes, Corn",
        'verified': true,
      },
      {
        'name': "Desh Agritech",
        'rating': 4.7,
        'boughtAmt': "95k kg",
        'preferred': "Mustard, Rice",
        'verified': true,
      },
      {
        'name': "Bhuiyan Cold Storage",
        'rating': 4.6,
        'boughtAmt': "80k kg",
        'preferred': "Potatoes",
        'verified': false,
      },
    ];

    Widget buildBuyerCard(Map<String, dynamic> buyer) {
      return _GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          buyer['name'],
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (buyer['verified']) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF54E167),
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  "${buyer['rating']}",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  buyer['boughtAmt'],
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 8),
            Text(
              "Preferred: ${buyer['preferred']}",
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFBCCBB7),
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Buyers in Your Area",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF54E167)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullListScreen(
                          title: "Top Buyers",
                          items:
                              topBuyers.map((b) => buildBuyerCard(b)).toList(),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                topBuyers.take(2).map((buyer) {
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
                    child: buildBuyerCard(buyer),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersPage() {
    final activeOrders =
        _orders
            .where(
              (o) => o['status'] != 'Delivered' && o['status'] != 'Completed',
            )
            .toList();
    final pastOrders =
        _orders
            .where(
              (o) => o['status'] == 'Delivered' || o['status'] == 'Completed',
            )
            .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 120),
      children: [
        Text(
          "My Orders",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54E167),
          ),
        ),
        Text(
          "Monitor, update delivery status, and review history",
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFFBCCBB7)),
        ),
        const SizedBox(height: 24),

        Text(
          "Active Deliveries (${activeOrders.length})",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (activeOrders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                "No active orders.",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
            ),
          )
        else
          ...activeOrders.map(
            (ord) => _buildOrderCardItem(ord, isActive: true),
          ),

        const SizedBox(height: 32),

        Text(
          "Past Orders (${pastOrders.length})",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (pastOrders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                "No past orders.",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
            ),
          )
        else
          ...pastOrders.map((ord) => _buildOrderCardItem(ord, isActive: false)),
      ],
    );
  }

  Widget _buildOrderCardItem(
    Map<String, dynamic> ord, {
    required bool isActive,
  }) {
    Color statusColor = Colors.amber;
    if (ord['status'] == 'In Transit') statusColor = Colors.blueAccent;
    if (ord['status'] == 'Delivered' || ord['status'] == 'Completed') {
      statusColor = const Color(0xFF54E167);
    }
    if (ord['status'] == 'Bid Pending') statusColor = Colors.purpleAccent;

    return GestureDetector(
      onTap: () => _showOrderDetailsDialog(ord),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                  ord['id'],
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF54E167),
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ord['status'],
                    style: GoogleFonts.plusJakartaSans(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ord['crop'],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Qty: ${ord['qty']} @ ${ord['price']}",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFBCCBB7),
                    fontSize: 13,
                  ),
                ),
                Text(
                  ord['date'],
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.business, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Buyer: ${ord['buyer']}",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (ord['status'] == 'Processing')
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          ord['status'] = 'In Transit';
                        });
                      },
                      icon: const Icon(Icons.local_shipping, size: 14),
                      label: const Text("Ship Order"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  if (ord['status'] == 'In Transit')
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          ord['status'] = 'Delivered';
                        });
                      },
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text("Mark Delivered"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF54E167),
                        foregroundColor: const Color(0xFF00390E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  if (ord['status'] == 'Bid Pending')
                    Text(
                      "Awaiting buyer response...",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showOrderDetailsDialog(Map<String, dynamic> ord) {
    final bool isAccepted = ord['status'] != 'Bid Pending';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF122131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Details",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Order ID", ord['id']),
              _buildDetailRow("Crop", ord['crop']),
              _buildDetailRow("Quantity", ord['qty']),
              _buildDetailRow("Price per kg", ord['price']),
              _buildDetailRow("Date", ord['date']),
              _buildDetailRow("Buyer", ord['buyer']),
              _buildDetailRow("Status", ord['status']),

              if (isAccepted) ...[
                const SizedBox(height: 24),
                Text(
                  "Contact Buyer",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCallSimulator(ord['buyer']);
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text("Call Buyer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF54E167),
                          foregroundColor: const Color(0xFF00390E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showExpertChatSheet(ord['buyer']);
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text("Message"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF54E167),
                          side: const BorderSide(color: Color(0xFF54E167)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showCallSimulator(String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF051424),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_in_talk,
                  color: Color(0xFF54E167),
                  size: 48,
                ),
                const SizedBox(height: 24),
                Text(
                  "Krishinet In-App Call",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Connecting...",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 48),
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketPage() {
    final List<Map<String, String>> suggestions =
        _farmerListings.where((listing) {
          final crop = (listing['crop'] ?? "").toLowerCase();
          final query = _marketSearchQuery.toLowerCase();
          return crop.contains(query) && crop != query;
        }).toList();

    // Filter by name (case-insensitive substring match)
    final List<Map<String, String>> displayedListings =
        _farmerListings.where((listing) {
          final cropName = (listing['crop'] ?? "").toLowerCase();
          final query = _marketSearchQuery.toLowerCase();
          return cropName.contains(query);
        }).toList();

    // Helper functions to parse numbers for sorting
    double getPriceValue(Map<String, String> item) {
      final priceStr = item['price']!.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(priceStr) ?? 0.0;
    }

    double getQtyValue(Map<String, String> item) {
      final qtyStr = item['demandedQty']!.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(qtyStr) ?? 0.0;
    }

    double getRatingValue(Map<String, String> item) {
      return double.tryParse(item['buyerRating'] ?? '0.0') ?? 0.0;
    }

    // Sort listings based on selection
    if (_marketSortOption == 'price_l2h') {
      displayedListings.sort(
        (a, b) => getPriceValue(a).compareTo(getPriceValue(b)),
      );
    } else if (_marketSortOption == 'price_h2l') {
      displayedListings.sort(
        (a, b) => getPriceValue(b).compareTo(getPriceValue(a)),
      );
    } else if (_marketSortOption == 'qty_l2h') {
      displayedListings.sort(
        (a, b) => getQtyValue(a).compareTo(getQtyValue(b)),
      );
    } else if (_marketSortOption == 'qty_h2l') {
      displayedListings.sort(
        (a, b) => getQtyValue(b).compareTo(getQtyValue(a)),
      );
    } else if (_marketSortOption == 'rating_h2l') {
      displayedListings.sort(
        (a, b) => getRatingValue(b).compareTo(getRatingValue(a)),
      );
    } else if (_marketSortOption == 'name_a2z') {
      displayedListings.sort(
        (a, b) => (a['crop'] ?? "").compareTo(b['crop'] ?? ""),
      );
    } else if (_marketSortOption == 'name_z2a') {
      displayedListings.sort(
        (a, b) => (b['crop'] ?? "").compareTo(a['crop'] ?? ""),
      );
    } else if (_marketSortOption == 'newest') {
      displayedListings.sort(
        (a, b) => (b['date'] ?? "").compareTo(a['date'] ?? ""),
      );
    } else if (_marketSortOption == 'oldest') {
      displayedListings.sort(
        (a, b) => (a['date'] ?? "").compareTo(b['date'] ?? ""),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
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

              // Pinned Search bar & filter row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _marketSearchController,
                      onChanged: (val) {
                        setState(() {
                          _marketSearchQuery = val;
                        });
                      },
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
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _showMarketFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF54E167).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF54E167).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFF54E167)),
                    ),
                  ),
                ],
              ),

              // Scrollable listings
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 20, bottom: 120),
                  children: [
                    if (_marketSortOption != 'none') ...[
                      Row(
                        children: [
                          InputChip(
                            label: Text(
                              _getSortLabel(_marketSortOption),
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF00390E),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: const Color(0xFF54E167),
                            onDeleted: () {
                              setState(() {
                                _marketSortOption = 'none';
                              });
                            },
                            deleteIconColor: const Color(0xFF00390E),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      "Available Buyer Requests",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (displayedListings.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            "No buyer requests matching \"$_marketSearchQuery\"",
                            style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...displayedListings.map(
                        (listing) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildMarketListingCard(
                            crop: listing['crop'] ?? "",
                            demandedQty: listing['demandedQty'] ?? "",
                            price: listing['price'] ?? "",
                            location: listing['location'] ?? "",
                            buyerName: listing['buyerName'] ?? "",
                            buyerRating: listing['buyerRating'] ?? "5.0",
                            date: listing['date'] ?? "2026-07-23",
                            onBid: () => _showBidOfferDialog(listing),
                            onAccept: () => _acceptDirectListing(listing),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating overlay suggestions dropdown (Positioned under the search bar)
        if (_marketSearchQuery.isNotEmpty && suggestions.isNotEmpty)
          Positioned(
            top: 212, // 80 padding + 56 header + 20 gap + 56 search height
            left: 20,
            right: 72, // aligns with search bar width (leaves filter button space)
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF122131),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: suggestions.take(4).map((sug) {
                  final cropName = sug['crop'] ?? "";
                  final demandedQty = sug['demandedQty'] ?? "";
                  final price = sug['price'] ?? "";
                  final imagePath = _getCropImage(cropName);

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Row(
                      children: [
                        // Left side content: Name, Qty, Price per kg
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cropName,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "Qty: $demandedQty",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFFBCCBB7),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Price: $price",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF54E167),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Right side image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            imagePath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _marketSearchController.text = cropName;
                      setState(() {
                        _marketSearchQuery = cropName;
                      });
                    },
                  );
                }).toList(),
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
    required String buyerRating,
    required String date,
    required VoidCallback onBid,
    required VoidCallback onAccept,
  }) {
    final String imagePath = _getCropImage(crop);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(imagePath, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Text(
                    crop,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Volume Required: $demandedQty",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF54E167),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    widget.isGuest
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                            child: Text(
                              location,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          )
                        : Text(
                            location,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                    const Spacer(),
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.business, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    widget.isGuest
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                            child: Text(
                              buyerName,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          )
                        : Text(
                            buyerName,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      buyerRating,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onBid,
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
                        onPressed: onAccept,
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
          ),
        ],
      ),
    );
  }

  String _getSortLabel(String option) {
    switch (option) {
      case 'name_a2z':
        return 'Name: A to Z';
      case 'name_z2a':
        return 'Name: Z to A';
      case 'price_l2h':
        return 'Price: Low to High';
      case 'price_h2l':
        return 'Price: High to Low';
      case 'qty_l2h':
        return 'Quantity: Low to High';
      case 'qty_h2l':
        return 'Quantity: High to Low';
      case 'rating_h2l':
        return 'Buyer Rating: High to Low';
      case 'newest':
        return 'Date: New to Old';
      case 'oldest':
        return 'Date: Old to New';
      default:
        return 'Sorted';
    }
  }

  void _showMarketFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF122131),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Widget buildSortOption(String option, String label, IconData icon) {
              final isSelected = _marketSortOption == option;
              return ListTile(
                leading: Icon(
                  icon,
                  color: isSelected ? const Color(0xFF54E167) : Colors.grey,
                ),
                title: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? Colors.white : const Color(0xFFBCCBB7),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing:
                    isSelected
                        ? const Icon(Icons.check, color: Color(0xFF54E167))
                        : null,
                onTap: () {
                  setSheetState(() {
                    _marketSortOption = option;
                  });
                  setState(() {
                    _marketSortOption = option;
                  });
                  Navigator.pop(context);
                },
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sort & Filter Market",
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
                  Expanded(
                    child: ListView(
                      children: [
                        buildSortOption('none', 'Default Order', Icons.sort),
                        buildSortOption(
                          'name_a2z',
                          'Name: A to Z',
                          Icons.title,
                        ),
                        buildSortOption(
                          'name_z2a',
                          'Name: Z to A',
                          Icons.title,
                        ),
                        buildSortOption(
                          'price_l2h',
                          'Price: Low to High',
                          Icons.arrow_upward,
                        ),
                        buildSortOption(
                          'price_h2l',
                          'Price: High to Low',
                          Icons.arrow_downward,
                        ),
                        buildSortOption(
                          'qty_l2h',
                          'Quantity: Low to High',
                          Icons.keyboard_double_arrow_up,
                        ),
                        buildSortOption(
                          'qty_h2l',
                          'Quantity: High to Low',
                          Icons.keyboard_double_arrow_down,
                        ),
                        buildSortOption(
                          'rating_h2l',
                          'Buyer Rating: High to Low',
                          Icons.star,
                        ),
                        buildSortOption(
                          'newest',
                          'Date: New to Old',
                          Icons.calendar_today,
                        ),
                        buildSortOption(
                          'oldest',
                          'Date: Old to New',
                          Icons.calendar_today,
                        ),
                      ],
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
        _profileOptionTile(
          "My Farm Details & Crops",
          Icons.agriculture,
          () => _showFarmDetailsSheet(context),
        ),
        const SizedBox(height: 12),
        _profileOptionTile(
          "Transaction History",
          Icons.history,
          () => _showTransactionHistorySheet(context),
        ),
        const SizedBox(height: 12),
        _profileOptionTile(
          "Krishinet Support Portal",
          Icons.support_agent,
          () => _showSupportPortalSheet(context),
        ),
        const SizedBox(height: 12),
        _profileOptionTile(
          "Settings & Language",
          Icons.settings,
          () => _showSettingsSheet(context),
        ),
        const SizedBox(height: 28),

        // Agricultural Calculators Section
        Row(
          children: [
            const Icon(Icons.calculate, color: Color(0xFF54E167), size: 20),
            const SizedBox(width: 8),
            Text(
              "Agricultural Calculators",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCalculatorCard(
                "Profit Calculator",
                "Estimate ROI & net revenue",
                Icons.calculate,
                () => _showProfitCalculator(context),
              ),
              const SizedBox(width: 12),
              _buildCalculatorCard(
                "Land Unit Converter",
                "Convert decimals to acres & bigha",
                Icons.square_foot,
                () => _showLandCalculator(context),
              ),
              const SizedBox(width: 12),
              _buildCalculatorCard(
                "Fertilizer & Pesticide",
                "Get recommended chemical dosages",
                Icons.science,
                () => _showPesticideCalculator(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

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
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: "Market",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Orders",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

// Interactive Bottom Sheets & Calculators

  void _showOrderDetailsSheet(BuildContext context, Map<String, dynamic> ord) {
    Color themeGreen = const Color(0xFF54E167);
    Color themeBg = const Color(0xFF0F1E2E);
    Color borderCol = const Color(0xFF1E2E3E);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: themeBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderCol),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ord['id'] ?? 'ORD-9871',
                    style: GoogleFonts.plusJakartaSans(
                      color: themeGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ord['status'],
                      style: GoogleFonts.plusJakartaSans(
                        color: themeGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                ord['crop'],
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Placed on ${ord['date'] ?? '2026-07-23'}",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 13),
              ),
              const Divider(color: Colors.white12, height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailTile("Quantity", ord['qty'] ?? '1,000 kg', Icons.shopping_bag),
                  ),
                  Expanded(
                    child: _buildDetailTile("Unit Price", ord['price'] ?? '৳25 / kg', Icons.monetization_on),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailTile("Buyer", ord['buyer'], Icons.business),
              const Divider(color: Colors.white12, height: 32),
              Text(
                "Tracking Timeline",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 16),
              _buildTrackingStep("Order Received", "Successfully matched bid", true, true),
              _buildTrackingStep("Processing", "Securing logistics partner", ord['status'] != 'Bid Pending', true),
              _buildTrackingStep("In Transit", "Heading to storage warehouse", ord['status'] == 'In Transit' || ord['status'] == 'Delivered', true),
              _buildTrackingStep("Delivered", "Crops inspected & payout initiated", ord['status'] == 'Delivered', false),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeGreen,
                    foregroundColor: const Color(0xFF00390E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Close Details",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAdvisoryDetailsSheet(BuildContext context, Map<String, dynamic> adv) {
    Color themeGreen = const Color(0xFF54E167);
    Color themeBg = const Color(0xFF0F1E2E);
    Color borderCol = const Color(0xFF1E2E3E);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: themeBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderCol),
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
                  Icon(
                    adv['icon'] as IconData,
                    color: themeGreen,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      adv['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "High Priority Advisory",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFFF5252),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const Divider(color: Colors.white12, height: 32),
              Text(
                "Recommendation Details",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                adv['desc'] as String,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFBCCBB7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: themeGreen, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Scientific Breakdown",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getAdvisoryBreakdown(adv['title'] as String),
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFBCCBB7),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeGreen,
                    foregroundColor: const Color(0xFF00390E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Got it, Thanks!",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFarmDetailsSheet(BuildContext context) {
    final sizeCtrl = TextEditingController(text: _farmLandSize);
    final cropCtrl = TextEditingController(text: _farmPrimaryCrop);
    final phCtrl = TextEditingController(text: _soilPhValue);
    final sowCtrl = TextEditingController(text: _lastSowedDate);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F1E2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                Text(
                  "My Farm Details & Crops",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFormTextField("Land Size (Acres)", sizeCtrl, Icons.square_foot),
                const SizedBox(height: 12),
                _buildFormTextField("Primary Crop Type", cropCtrl, Icons.agriculture),
                const SizedBox(height: 12),
                _buildFormTextField("Soil pH Level", phCtrl, Icons.science),
                const SizedBox(height: 12),
                _buildFormTextField("Last Sown Date (YYYY-MM-DD)", sowCtrl, Icons.date_range),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                           padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _farmLandSize = sizeCtrl.text.trim();
                            _farmPrimaryCrop = cropCtrl.text.trim();
                            _soilPhValue = phCtrl.text.trim();
                            _lastSowedDate = sowCtrl.text.trim();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Farm details saved successfully!"),
                              backgroundColor: Color(0xFF54E167),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF54E167),
                          foregroundColor: const Color(0xFF00390E),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Save Changes"),
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
  }

  void _showTransactionHistorySheet(BuildContext context) {
    final List<Map<String, dynamic>> txs = [
      {
        'title': 'Aarong Dairy Payout for Paddy',
        'amount': '+৳45,200',
        'type': 'payout',
        'date': '2026-07-20',
      },
      {
        'title': 'BADC Aman Seeds Purchase',
        'amount': '-৳2,400',
        'type': 'expense',
        'date': '2026-07-15',
      },
      {
        'title': 'Government Agri-subsidy Deposit',
        'amount': '+৳8,500',
        'type': 'subsidy',
        'date': '2026-07-10',
      },
      {
        'title': 'Fertilizer purchase (MOP/Urea)',
        'amount': '-৳3,100',
        'type': 'expense',
        'date': '2026-07-05',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F1E2E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              Text(
                "Transaction History",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: txs.length,
                  itemBuilder: (context, index) {
                    final tx = txs[index];
                    final isPositive = tx['type'] != 'expense';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx['title'],
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tx['date'],
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            tx['amount'],
                            style: GoogleFonts.plusJakartaSans(
                              color: isPositive ? const Color(0xFF54E167) : const Color(0xFFFF5252),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF54E167),
                    foregroundColor: const Color(0xFF00390E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Close ledger"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSupportPortalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F1E2E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  const Icon(Icons.support_agent, color: Color(0xFF54E167), size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Krishinet Support Portal",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Common Questions (FAQ)",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              _buildFaqItem("How do I withdraw my earnings?", "Go to profile, check earnings, and link your bKash, Nagad or bank account to request instant payouts."),
              _buildFaqItem("When will my crops be collected?", "Once a buyer accepts your offer, the transit driver will contact you to pick up crops within 48 hours."),
              _buildFaqItem("How to get free soil testing?", "Contact your Upazila Agriculture office or use our Krishi-Expert chat section to submit soil images for diagnosis."),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Support agent will contact you shortly!"),
                        backgroundColor: Color(0xFF54E167),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble),
                  label: const Text("Open Live Chat Support"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF54E167),
                    foregroundColor: const Color(0xFF00390E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsSheet(BuildContext context) {
    bool notifyEnabled = true;
    bool smsEnabled = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0F1E2E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  Text(
                    "Settings & Language",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "App Language",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("English (US)", style: TextStyle(color: Color(0xFF00390E))),
                        selected: true,
                        onSelected: (val) {},
                        selectedColor: const Color(0xFF54E167),
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text("Bangla (বাংলাদেশ)"),
                        selected: false,
                        onSelected: (val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("বাংলা ভাষা শীঘ্রই যুক্ত করা হবে")),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 32),
                  SwitchListTile(
                    title: const Text("Push Notifications", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("Get updates when bids are placed on your crops", style: TextStyle(color: Colors.grey, fontSize: 11)),
                    value: notifyEnabled,
                    activeThumbColor: const Color(0xFF54E167),
                    onChanged: (val) {
                      setModalState(() {
                        notifyEnabled = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text("Direct SMS Alerts", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("Receive SMS warnings for low soil moisture and weather advisories", style: TextStyle(color: Colors.grey, fontSize: 11)),
                    value: smsEnabled,
                    activeThumbColor: const Color(0xFF54E167),
                    onChanged: (val) {
                      setModalState(() {
                        smsEnabled = val;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Settings updated successfully!"),
                            backgroundColor: Color(0xFF54E167),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF54E167),
                        foregroundColor: const Color(0xFF00390E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save & Apply"),
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

  void _showProfitCalculator(BuildContext context) {
    final yieldCtrl = TextEditingController(text: "1000");
    final priceCtrl = TextEditingController(text: "28");
    final costCtrl = TextEditingController(text: "15000");

    double profit = 13000;
    double roi = 86.67;

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
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1E2E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                        const Icon(Icons.calculate, color: Color(0xFF54E167), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Crop Profit & ROI Calculator",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFormTextField("Estimated Yield (kg)", yieldCtrl, Icons.shopping_bag),
                    const SizedBox(height: 12),
                    _buildFormTextField("Expected Market Price (৳ / kg)", priceCtrl, Icons.monetization_on),
                    const SizedBox(height: 12),
                    _buildFormTextField("Total Cost of Production (৳)", costCtrl, Icons.account_balance),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Estimated Revenue:", style: TextStyle(color: Colors.grey[400])),
                              Text("৳${(double.tryParse(yieldCtrl.text) ?? 0) * (double.tryParse(priceCtrl.text) ?? 0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Net Profit:", style: TextStyle(color: Colors.grey[400])),
                              Text("৳$profit", style: const TextStyle(color: Color(0xFF54E167), fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Return on Investment (ROI):", style: TextStyle(color: Colors.grey[400])),
                              Text("$roi%", style: const TextStyle(color: Color(0xFF54E167), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final yld = double.tryParse(yieldCtrl.text) ?? 0;
                              final prc = double.tryParse(priceCtrl.text) ?? 0;
                              final cst = double.tryParse(costCtrl.text) ?? 0;
                              final rev = yld * prc;
                              setModalState(() {
                                profit = rev - cst;
                                roi = cst > 0 ? double.parse(((profit / cst) * 100).toStringAsFixed(2)) : 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF54E167),
                              foregroundColor: const Color(0xFF00390E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Calculate"),
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

  void _showLandCalculator(BuildContext context) {
    final decimalCtrl = TextEditingController(text: "100");
    double acres = 1.0;
    double bigha = 3.03;
    double katha = 60.6;
    double paddySeed = 10.0;

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
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1E2E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                        const Icon(Icons.square_foot, color: Color(0xFF54E167), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Land Unit Converter",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFormTextField("Area in Decimals (শতক)", decimalCtrl, Icons.straighten),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Acres (একর):", style: TextStyle(color: Colors.grey[400])),
                              Text("$acres", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Bigha (বিঘা - standard):", style: TextStyle(color: Colors.grey[400])),
                              Text("$bigha", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Katha (কাঠা):", style: TextStyle(color: Colors.grey[400])),
                              Text("$katha", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Est. Seed Needed (Paddy):", style: TextStyle(color: Colors.grey[400])),
                              Text("${paddySeed.toStringAsFixed(1)} kg", style: const TextStyle(color: Color(0xFF54E167), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final dec = double.tryParse(decimalCtrl.text) ?? 0;
                              setModalState(() {
                                acres = double.parse((dec / 100).toStringAsFixed(2));
                                bigha = double.parse((dec / 33).toStringAsFixed(2));
                                katha = double.parse((dec / 1.65).toStringAsFixed(2));
                                paddySeed = acres * 10;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF54E167),
                              foregroundColor: const Color(0xFF00390E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Convert"),
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

  void _showPesticideCalculator(BuildContext context) {
    final decCtrl = TextEditingController(text: "100");
    String selectedCrop = "Paddy";

    double urea = 80.0;
    double tsp = 40.0;
    double mop = 50.0;
    double pesticide = 5.0;

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
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1E2E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                        const Icon(Icons.science, color: Color(0xFF54E167), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Fertilizer & Pesticide Dosage",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Select Crop Type",
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCrop,
                      dropdownColor: const Color(0xFF0F1E2E),
                      items: const [
                        DropdownMenuItem(value: "Paddy", child: Text("Paddy (Rice)")),
                        DropdownMenuItem(value: "Wheat", child: Text("Wheat")),
                        DropdownMenuItem(value: "Potato", child: Text("Potato")),
                      ],
                      onChanged: (val) {
                        setModalState(() {
                          selectedCrop = val!;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1E2E3E),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFormTextField("Land Size in Decimals (শতক)", decCtrl, Icons.straighten),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Urea required:", style: TextStyle(color: Colors.grey[400])),
                              Text("${urea.toStringAsFixed(1)} kg", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("TSP required:", style: TextStyle(color: Colors.grey[400])),
                              Text("${tsp.toStringAsFixed(1)} kg", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("MOP required:", style: TextStyle(color: Colors.grey[400])),
                              Text("${mop.toStringAsFixed(1)} kg", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Bio-Pesticide spray:", style: TextStyle(color: Colors.grey[400])),
                              Text("${pesticide.toStringAsFixed(1)} Liters", style: const TextStyle(color: Color(0xFF54E167), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final dec = double.tryParse(decCtrl.text) ?? 0;
                              setModalState(() {
                                if (selectedCrop == "Paddy") {
                                  urea = dec * 0.8;
                                  tsp = dec * 0.4;
                                  mop = dec * 0.5;
                                  pesticide = dec * 0.05;
                                } else if (selectedCrop == "Wheat") {
                                  urea = dec * 1.0;
                                  tsp = dec * 0.5;
                                  mop = dec * 0.4;
                                  pesticide = dec * 0.03;
                                } else {
                                  urea = dec * 1.2;
                                  tsp = dec * 0.7;
                                  mop = dec * 0.8;
                                  pesticide = dec * 0.08;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF54E167),
                              foregroundColor: const Color(0xFF00390E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Calculate Dosage"),
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

  Widget _buildCalculatorCard(String title, String desc, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF54E167).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF54E167), size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFBCCBB7),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getAdvisoryBreakdown(String title) {
    if (title.contains("Water")) {
      return "Paddy tillering phase requires stable moisture. Dry soil results in high root impedance and low tiller numbers. Aim for constant 3cm depth.";
    } else if (title.contains("Potassium")) {
      return "Top-dressing with MOP (Muriate of Potash) before grain heading boosts resistance to blast diseases and improves starch transport to the grain panicles.";
    } else {
      return "Rice blast spore release peaks under humid (above 70%), warm conditions. Neem bio-fungicides acts as an organic system inhibitor to block spore growth.";
    }
  }

  Widget _buildDetailTile(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF54E167), size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 11),
            ),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackingStep(String title, String subtitle, bool isCompleted, bool showLine) {
    Color completedColor = const Color(0xFF54E167);
    Color pendingColor = Colors.white24;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? completedColor : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? completedColor : pendingColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 10, color: Color(0xFF00390E))
                  : null,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? completedColor : pendingColor,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: isCompleted ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  color: isCompleted ? const Color(0xFFBCCBB7) : Colors.grey.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFBCCBB7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFFBCCBB7), fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFBCCBB7), size: 20),
            filled: true,
            fillColor: const Color(0xFF1E2E3E),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
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

  const _GlassCard({required this.child, this.padding, this.borderRadius = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF122131).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
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

class TrendsChartPainter extends CustomPainter {
  final List<double> prices;
  final List<String> months;
  final Color lineColor;
  final Color textColor;

  TrendsChartPainter({
    required this.prices,
    required this.months,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final double maxVal = prices.reduce((a, b) => a > b ? a : b);
    final double minVal = prices.reduce((a, b) => a < b ? a : b);
    final double range = (maxVal - minVal == 0) ? 1.0 : (maxVal - minVal);

    const double leftPadding = 30.0;
    const double bottomPadding = 24.0;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    final int pointsCount = prices.length;
    final double dx = chartWidth / (pointsCount - 1);

    final List<Offset> points = [];
    for (int i = 0; i < pointsCount; i++) {
      final double x = leftPadding + (i * dx);
      final double normalizedY = (prices[i] - minVal) / range;
      final double y = chartHeight - (normalizedY * (chartHeight - 16));
      points.add(Offset(x, y));
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final yLabels = [minVal, (maxVal + minVal) / 2, maxVal];
    for (var label in yLabels) {
      final double normY = (label - minVal) / range;
      final double y = chartHeight - (normY * (chartHeight - 16));

      final String labelStr = label.toStringAsFixed(
        label == label.toInt() ? 0 : 1,
      );
      textPainter.text = TextSpan(
        text: "৳$labelStr",
        style: GoogleFonts.plusJakartaSans(color: textColor, fontSize: 8),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    final Paint linePaint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    final Path fillPath =
        Path()
          ..moveTo(points[0].dx, chartHeight)
          ..lineTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points[points.length - 1].dx, chartHeight);
    fillPath.close();

    final Paint fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.3),
              lineColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight))
          ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final Paint dotPaint =
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.fill;

    final Paint dotOutlinePaint =
        Paint()
          ..color = const Color(0xFF122131)
          ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5.0, dotPaint);
      canvas.drawCircle(points[i], 2.0, dotOutlinePaint);

      textPainter.text = TextSpan(
        text: months[i],
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SoldChartPainter extends CustomPainter {
  final List<double> quantities;
  final List<String> months;
  final Color lineColor;
  final Color textColor;

  SoldChartPainter({
    required this.quantities,
    required this.months,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (quantities.isEmpty) return;

    final double maxVal = quantities.reduce((a, b) => a > b ? a : b);
    final double minVal = quantities.reduce((a, b) => a < b ? a : b);
    final double range = (maxVal - minVal == 0) ? 1.0 : (maxVal - minVal);

    const double leftPadding = 45.0;
    const double bottomPadding = 24.0;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    final int pointsCount = quantities.length;
    final double dx = chartWidth / (pointsCount - 1);

    final List<Offset> points = [];
    for (int i = 0; i < pointsCount; i++) {
      final double x = leftPadding + (i * dx);
      final double normalizedY = (quantities[i] - minVal) / range;
      final double y = chartHeight - (normalizedY * (chartHeight - 16));
      points.add(Offset(x, y));
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    String formatQty(double val) {
      if (val >= 1000) {
        double kVal = val / 1000;
        return "${kVal.toStringAsFixed(kVal == kVal.toInt() ? 0 : 1)}k kg";
      }
      return "${val.toStringAsFixed(0)} kg";
    }

    final yLabels = [minVal, (maxVal + minVal) / 2, maxVal];
    for (var label in yLabels) {
      final double normY = (label - minVal) / range;
      final double y = chartHeight - (normY * (chartHeight - 16));

      textPainter.text = TextSpan(
        text: formatQty(label),
        style: GoogleFonts.plusJakartaSans(color: textColor, fontSize: 8),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    final Paint linePaint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    final Path fillPath =
        Path()
          ..moveTo(points[0].dx, chartHeight)
          ..lineTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points[points.length - 1].dx, chartHeight);
    fillPath.close();

    final Paint fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.3),
              lineColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight))
          ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final Paint dotPaint =
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.fill;

    final Paint dotOutlinePaint =
        Paint()
          ..color = const Color(0xFF122131)
          ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5.0, dotPaint);
      canvas.drawCircle(points[i], 2.0, dotOutlinePaint);

      textPainter.text = TextSpan(
        text: months[i],
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ExpertChatScreen extends StatefulWidget {
  final String expertName;
  const ExpertChatScreen({super.key, required this.expertName});

  @override
  State<ExpertChatScreen> createState() => _ExpertChatScreenState();
}

class _ExpertChatScreenState extends State<ExpertChatScreen> {
  late final List<Map<String, dynamic>> _messages = [
    {
      'sender': widget.expertName,
      'text': "Hello Rihin! How is your crop growing?",
      'isUser': false,
    },
    {
      'sender': "You",
      'text': "Growing well, just testing the new NPK diagnostic tool.",
      'isUser': true,
    },
  ];
  final TextEditingController _controller = TextEditingController();

  void _showCallSimulator(BuildContext context, String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF051424),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_in_talk,
                  color: Color(0xFF54E167),
                  size: 48,
                ),
                const SizedBox(height: 24),
                Text(
                  "Krishinet In-App Call",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Connecting...",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 48),
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExpertImagePicker(
    BuildContext context,
    Function(String) onImageSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2E3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attach Crop Image",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.spa, color: Color(0xFF54E167)),
                title: Text(
                  "Paddy Rice Leaf",
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected('assets/images/crop1.jpg');
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle_outlined, color: Colors.amber),
                title: Text(
                  "Potato Leaf",
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected('assets/images/crop2.jpg');
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_enhance, color: Colors.blue),
                title: Text(
                  "Wheat Leaf",
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected('assets/images/crop3.jpg');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatMessage({
    required String sender,
    required String text,
    required bool isUser,
    String? localAsset,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (localAsset != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    localAsset,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  color: isUser ? const Color(0xFFE4FFE7) : Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      appBar: AppBar(
        backgroundColor: const Color(0xFF122131),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.expertName,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Color(0xFF54E167)),
            onPressed: () => _showCallSimulator(context, widget.expertName),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatMessage(
                  sender: msg['sender'],
                  text: msg['text'],
                  isUser: msg['isUser'],
                  localAsset: msg['localAsset'],
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFF122131),
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_photo_alternate,
                    color: Color(0xFF54E167),
                    size: 26,
                  ),
                  onPressed: () {
                    _showExpertImagePicker(context, (selectedAsset) {
                      setState(() {
                        _messages.add({
                          'sender': "You",
                          'text': "Uploaded crop photo.",
                          'isUser': true,
                          'localAsset': selectedAsset,
                        });
                      });
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
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
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isEmpty) return;
                      _controller.clear();
                      setState(() {
                        _messages.add({
                          'sender': "You",
                          'text': text,
                          'isUser': true,
                        });
                      });
                    },
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

class FullListScreen extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const FullListScreen({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      appBar: AppBar(
        backgroundColor: const Color(0xFF122131),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: items[index],
          );
        },
      ),
    );
  }
}
