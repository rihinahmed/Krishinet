import 'dart:ui';
import 'package:flutter/material.dart';

class Officer {
  final String name;
  final String title;
  final String department;
  final String imageUrl;
  final String location;
  final bool isAvailable;

  Officer({
    required this.name,
    required this.title,
    required this.department,
    required this.imageUrl,
    required this.location,
    required this.isAvailable,
  });
}

class GovtPortalScreen extends StatefulWidget {
  final bool isEmbedded;
  const GovtPortalScreen({super.key, this.isEmbedded = false});

  @override
  State<GovtPortalScreen> createState() => _GovtPortalScreenState();
}

class _GovtPortalScreenState extends State<GovtPortalScreen> {
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

  String _selectedDept = "All";
  final List<String> _departments = [
    "All",
    "Agricultural Extension",
    "Crop Subventions",
    "Soil Research Council",
  ];

  late List<Officer> _officers;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _officers = [
      Officer(
        name: 'Dr. Tariq Mahmood',
        title: 'Director of Agricultural Expansion',
        department: 'Agricultural Extension',
        imageUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80',
        location: 'Krishi Bhavan, HQ',
        isAvailable: true,
      ),
      Officer(
        name: 'Ms. Shireen Akter',
        title: 'Senior Officer, Subventions & Grants',
        department: 'Crop Subventions',
        imageUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=150&q=80',
        location: 'Regional Office, South',
        isAvailable: true,
      ),
      Officer(
        name: 'Prof. Abdus Sobhan',
        title: 'Soil Science Policy Advisor',
        department: 'Soil Research Council',
        imageUrl:
            'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=150&q=80',
        location: 'Central Laboratory, North',
        isAvailable: false,
      ),
      Officer(
        name: 'Engr. Rakibul Islam',
        title: 'Director of Irrigation Schemes',
        department: 'Agricultural Extension',
        imageUrl:
            'https://images.unsplash.com/photo-1542909168-82c3e7fdca5c?auto=format&fit=crop&w=150&q=80',
        location: 'Krishi Bhavan, HQ',
        isAvailable: true,
      ),
    ];
  }

  void _openQueryDialog(Officer? initialOfficer) {
    Officer? selectedOfficer =
        initialOfficer ?? _officers.firstWhere((o) => o.isAvailable);
    final topicController = TextEditingController();
    final descController = TextEditingController();
    bool isSubmitting = false;
    bool isSuccess = false;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: glassBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: glassBorder, width: 1),
                    ),
                    child:
                        isSuccess
                            ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: primary,
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Query Submitted',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your official consultation query has been logged and sent to ${selectedOfficer!.name}. You will be alerted via DND logs.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: onSurfaceVariant,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: const Color(0xFF00390E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Return to Portal'),
                                ),
                              ],
                            )
                            : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Submit Officer Query',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Officer Selector
                                const Text(
                                  'RECIPIENT OFFICER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: surfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: glassBorder),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Officer>(
                                      dropdownColor: surfaceContainer,
                                      value: selectedOfficer,
                                      isExpanded: true,
                                      iconEnabledColor: primary,
                                      onChanged: (newOfficer) {
                                        if (newOfficer != null) {
                                          setDialogState(() {
                                            selectedOfficer = newOfficer;
                                          });
                                        }
                                      },
                                      items:
                                          _officers
                                              .map(
                                                (o) => DropdownMenuItem(
                                                  value: o,
                                                  child: Text(
                                                    o.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Form Inputs
                                const Text(
                                  'SUBJECT / TOPIC',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: topicController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'e.g. Rabi crop circular subvention rates',
                                    hintStyle: TextStyle(
                                      color: onSurfaceVariant.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: surfaceContainer,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: glassBorder,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: glassBorder,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'MESSAGE DETAIL',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: descController,
                                  minLines: 3,
                                  maxLines: 5,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Enter specific details about policy instructions...',
                                    hintStyle: TextStyle(
                                      color: onSurfaceVariant.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: surfaceContainer,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: glassBorder,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: glassBorder,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                ElevatedButton(
                                  onPressed:
                                      isSubmitting
                                          ? null
                                          : () {
                                            if (topicController.text.isEmpty ||
                                                descController.text.isEmpty) {
                                              return;
                                            }
                                            setDialogState(() {
                                              isSubmitting = true;
                                            });

                                            // Simulate loading / submit
                                            Future.delayed(
                                              const Duration(
                                                milliseconds: 1000,
                                              ),
                                              () {
                                                setDialogState(() {
                                                  isSubmitting = false;
                                                  isSuccess = true;
                                                });
                                              },
                                            );
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: const Color(0xFF00390E),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child:
                                      isSubmitting
                                          ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF00390E),
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Text(
                                            'Send Memo Request',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOfficers =
        _officers.where((officer) {
          final matchesSearch =
              officer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              officer.title.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesDept =
              _selectedDept == "All" || officer.department == _selectedDept;
          return matchesSearch && matchesDept;
        }).toList();

    Widget body = Column(
      children: [
        if (widget.isEmbedded) _buildHeaderBar(),

        // Department filter chips
        _buildDeptSelector(),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(color: onBackground, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search officers by title or name...',
              hintStyle: TextStyle(
                color: onSurfaceVariant.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(Icons.search, color: onSurfaceVariant),
              filled: true,
              fillColor: surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primary.withValues(alpha: 0.5)),
              ),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Circular Bulletins Section
                _buildSectionHeader('Official Bulletins & Directives'),
                const SizedBox(height: 12),
                _buildExpansionBulletin(
                  id: "1",
                  title: 'Fertilizer Subsidies Rabi Phase II',
                  date: 'Released: 2d ago',
                  detail:
                      'The government will sponsor up to 40% of Nitrogen-Potassium mixtures for farmers holding certified soil health profiles. Applications should be verified by certified regional agronomists under their profile hubs.',
                ),
                const SizedBox(height: 8),
                _buildExpansionBulletin(
                  id: "2",
                  title: 'Wheat Seed Distribution Schedule',
                  date: 'Released: 5d ago',
                  detail:
                      'Distribution starts from Nov 1st across Northern blocks. Direct seed drills are recommended due to low residual soil moisture metrics. Regional agronomists must review block level registers.',
                ),
                const SizedBox(height: 24),

                // Officer Directory Section
                _buildSectionHeader('Officer Directory'),
                const SizedBox(height: 12),
                if (filteredOfficers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No officers found for this department.',
                        style: TextStyle(color: onSurfaceVariant),
                      ),
                    ),
                  )
                else
                  ...filteredOfficers.map((o) => _buildOfficerCard(o)),
              ],
            ),
          ),
        ),
      ],
    );

    if (widget.isEmbedded) return body;

    return Scaffold(backgroundColor: background, body: SafeArea(child: body));
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Govt Officers Portal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: onBackground,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _openQueryDialog(null),
            icon: const Icon(Icons.mail_outline, size: 14),
            label: const Text(
              'New Query',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: const Color(0xFF00390E),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeptSelector() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        itemCount: _departments.length,
        itemBuilder: (context, index) {
          final dept = _departments[index];
          final isSelected = _selectedDept == dept;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                dept,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF00390E) : Colors.white,
                  fontSize: 11.5,
                ),
              ),
              selected: isSelected,
              selectedColor: primary,
              backgroundColor: surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              showCheckmark: false,
              side: BorderSide(color: isSelected ? primary : glassBorder),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedDept = dept;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildExpansionBulletin({
    required String id,
    required String title,
    required String date,
    required String detail,
  }) {
    return _buildGlassCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8.0),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(date, style: TextStyle(fontSize: 11, color: primary)),
          iconColor: primary,
          collapsedIconColor: onSurfaceVariant,
          children: [
            Text(
              detail,
              style: TextStyle(
                fontSize: 12.5,
                color: onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficerCard(Officer o) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _buildGlassCard(
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(o.imageUrl)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.name,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    o.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 13,
                        color: onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        o.location,
                        style: TextStyle(fontSize: 11, color: onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color:
                    o.isAvailable
                        ? primary
                        : onSurfaceVariant.withValues(alpha: 0.3),
              ),
              onPressed: o.isAvailable ? () => _openQueryDialog(o) : null,
              style: IconButton.styleFrom(
                backgroundColor: surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
