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

  late List<Officer> _officers;

  // Static list of official schemes
  final List<Map<String, String>> _schemes = [
    {
      'title': 'Rabi Fertilizer Subsidy Phase II',
      'detail': 'Get up to 40% reimbursement on Nitrogen-Potassium mixtures. Soil health profile card required.',
      'deadline': 'Dec 15, 2026',
      'status': 'Pending Officer Verification',
      'officer': 'Ms. Shireen Akter (Subventions Senior Officer)',
    },
    {
      'title': 'Solar Irrigation Pump Support',
      'detail': 'Capital support scheme covering 70% cost of off-grid solar pump installation for verified cooperatives.',
      'deadline': 'Nov 30, 2026',
      'status': 'Verified by Govt Officer',
      'officer': 'Dr. Tariq Mahmood (Expansion Director)',
    },
    {
      'title': 'Crop Insurance Premium Grant',
      'detail': 'Covers 80% crop insurance premiums against severe weather/floods for wheat, paddy, and jute crops.',
      'deadline': 'Oct 31, 2026',
      'status': 'Pending Officer Verification',
      'officer': 'Ms. Shireen Akter (Subventions Senior Officer)',
    },
  ];

  // Static list of policy advisories sent to experts
  final List<Map<String, String>> _advisories = [
    {
      'title': 'Mitigating Boro Paddy Leaf Blast',
      'requestedBy': 'Ministry of Agricultural Expansion',
      'deadline': 'In 3 days',
      'status': 'Pending Draft',
    },
    {
      'title': 'Post-Flood Soil Remediation Directive',
      'requestedBy': 'Soil Research Council',
      'deadline': 'Submitted',
      'status': 'Approved',
    },
    {
      'title': 'Short-Duration Mustard Cultivation Guidelines',
      'requestedBy': 'Agricultural Policy Division',
      'deadline': 'Completed',
      'status': 'Published',
    },
  ];

  // Static quota allocations per division
  final List<Map<String, String>> _divisionQuotas = [
    {
      'division': 'Dhaka Division',
      'seedQuota': '4,200 MT Wheat • 2,100 MT Mustard',
      'fertilizerQuota': '5,800 MT MOP • 8,400 MT Urea',
    },
    {
      'division': 'Rajshahi Division',
      'seedQuota': '7,500 MT Wheat • 3,800 MT Mustard',
      'fertilizerQuota': '10,500 MT Urea • 6,200 MT TSP',
    },
    {
      'division': 'Rangpur Division',
      'seedQuota': '5,200 MT Wheat • 4,500 MT Maize',
      'fertilizerQuota': '8,200 MT TSP • 9,500 MT Urea',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        if (widget.isEmbedded) _buildHeaderBar(),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Govt Subsidies & Schemes Section
                _buildSectionHeader('Agri-Subsidies & Grants Hub', Icons.workspace_premium),
                const SizedBox(height: 12),
                ..._schemes.map((s) => _buildSchemeCard(s)),
                const SizedBox(height: 24),

                // 2. Official Circulars & Bulletins
                _buildSectionHeader('Official Bulletins & Directives', Icons.campaign_outlined),
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

                // 3. Agronomic Advisories Tasks
                _buildSectionHeader('Expert Advisory Directives', Icons.assignment_outlined),
                const SizedBox(height: 12),
                ..._advisories.map((a) => _buildAdvisoryCard(a)),
                const SizedBox(height: 24),

                // 4. Divisional Allocation Tracker
                _buildSectionHeader('Divisional Quota Allocations', Icons.grid_view_outlined),
                const SizedBox(height: 12),
                ..._divisionQuotas.map((q) => _buildQuotaCard(q)),
                const SizedBox(height: 24),

                // 5. Officer Directory Section
                _buildSectionHeader('Ministry Officer Directory', Icons.contact_mail_outlined),
                const SizedBox(height: 12),
                ..._officers.map((o) => _buildOfficerCard(o)),
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
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSchemeCard(Map<String, String> s) {
    final isVerified = s['status'] == 'Verified by Govt Officer';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _buildGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    s['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isVerified ? primary.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isVerified ? primary.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    isVerified ? "VERIFIED" : "PENDING",
                    style: TextStyle(
                      color: isVerified ? primary : Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              s['detail']!,
              style: TextStyle(color: onSurfaceVariant, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isVerified ? Icons.verified_user : Icons.hourglass_empty,
                  color: isVerified ? primary : Colors.orange,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    isVerified ? "Verified by Officer: ${s['officer']}" : "Assigned Officer: ${s['officer']}",
                    style: TextStyle(
                      color: isVerified ? primary.withValues(alpha: 0.8) : Colors.orange.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Deadline: ${s['deadline']}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isVerified) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: surfaceContainer,
                          title: Text("Official Scheme Certificate", style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                          content: Text(
                            "This scheme has been officially verified and certified by ${s['officer']}.\n\nCertificate ID: GOV-SUB-${s['title']!.hashCode.abs()}\nDate: July 2026",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            )
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Notification request sent to ${s['officer']} to verify eligibility!"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerified ? primary : Colors.orange,
                    foregroundColor: const Color(0xFF00390E),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    isVerified ? "View Certificate" : "Notify Officer",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryCard(Map<String, String> a) {
    final isPending = a['status'] == 'Pending Draft';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _buildGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    a['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ),
                Text(
                  a['status']!,
                  style: TextStyle(
                    color: isPending ? error : primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Requested By: ${a['requestedBy']}",
              style: TextStyle(color: onSurfaceVariant, fontSize: 11.5),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPending ? "Action: Draft Advisory" : "Action: Complete",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isPending ? "Opened advisory template for draft." : "Downloading advisory document circular..."),
                        backgroundColor: primary,
                      ),
                    );
                  },
                  icon: Icon(isPending ? Icons.edit_note : Icons.download, size: 14),
                  label: Text(
                    isPending ? "Draft Advisory" : "Download PDF",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPending ? error.withValues(alpha: 0.1) : primary.withValues(alpha: 0.1),
                    foregroundColor: isPending ? error : primary,
                    side: BorderSide(color: isPending ? error.withValues(alpha: 0.3) : primary.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotaCard(Map<String, String> q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _buildGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q['division']!,
              style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.eco_outlined, color: Colors.white54, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Seed Quota: ${q['seedQuota']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.opacity_outlined, color: Colors.white54, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Fertilizer Quota: ${q['fertilizerQuota']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
