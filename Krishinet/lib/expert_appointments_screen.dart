import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF051424);
  static const Color surfaceContainer = Color(0xFF122131);
  static const Color surfaceContainerHigh = Color(0xFF1C2B3C);
  static const Color surfaceContainerHighest = Color(0xFF273647);
  static const Color primary = Color(0xFF54E167);
  static const Color primaryContainer = Color(0xFF2CC04B);
  static const Color onBackground = Color(0xFFD4E4FA);
  static const Color onSurfaceVariant = Color(0xFFBCCBB7);
  static const Color glassBackground = Color(0xB3122131);
  static const Color glassBorder = Color(0x0DFFFFFF);
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: child,
        ),
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

class ExpertAppointmentsScreen extends StatefulWidget {
  final bool isEmbedded;
  final Function(int tabIndex, String farmerName)? onNavigateToTab;
  const ExpertAppointmentsScreen({super.key, this.isEmbedded = false, this.onNavigateToTab});

  @override
  State<ExpertAppointmentsScreen> createState() =>
      _ExpertAppointmentsScreenState();
}

class _ExpertAppointmentsScreenState extends State<ExpertAppointmentsScreen> {
  String _activeTab = 'Upcoming';
  final List<Map<String, String>> _appointments = [
    {
      'title': 'Soil Health Review',
      'farmer': 'Kalam Miah',
      'phone': '01711223344',
      'time': 'Today, 10:00 AM',
      'type': 'Soil / Crop',
      'status': 'Upcoming',
    },
    {
      'title': 'Pest Outbreak Analysis',
      'farmer': 'Sufia Begum',
      'phone': '01899887766',
      'time': 'Today, 01:30 PM',
      'type': 'Pest Warning',
      'status': 'Upcoming',
    },
    {
      'title': 'Animal Nutrition Advice',
      'farmer': 'Abdul Baten',
      'phone': '01912345678',
      'time': 'Tomorrow, 11:00 AM',
      'type': 'Livestock',
      'status': 'Upcoming',
    },
    {
      'title': 'Aman Paddy Consultation',
      'farmer': 'Amena Bibi',
      'phone': '01511223344',
      'time': 'Yesterday, 03:00 PM',
      'type': 'Crop',
      'status': 'Completed',
    },
  ];

  Future<void> _rescheduleAppointment(Map<String, String> app) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Color(0xFF00390E),
              surface: AppColors.surfaceContainer,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Color(0xFF00390E),
              surface: AppColors.surfaceContainer,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    if (!mounted) return;

    final formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    final formattedTime = pickedTime.format(context);

    setState(() {
      app['time'] = "$formattedDate, $formattedTime";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Consultation successfully rescheduled to $formattedDate at $formattedTime!"),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _appointments.where((a) => a['status'] == _activeTab).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Consultations",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage virtual calls, soil audits, and animal checkups.",
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              // Segmented Tab bar
              Row(
                children: ['Upcoming', 'Completed'].map((tab) {
                  final isSelected = _activeTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      backgroundColor: AppColors.surfaceContainer,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _activeTab = tab;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    filtered.isEmpty
                        ? const Center(
                          child: Text(
                            "No appointments in this category.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) {
                            final app = filtered[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: GlassCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          app['title']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            app['type']!,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Farmer: ${app['farmer']} (${app['phone']})",
                                      style: const TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Time: ${app['time']}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (app['status'] == 'Upcoming') ...[
                                      const Divider(
                                        color: Colors.white12,
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => _rescheduleAppointment(app),
                                            child: const Text(
                                              "Reschedule",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.message_outlined, color: AppColors.primary, size: 18),
                                            tooltip: "Message Farmer",
                                            onPressed: () {
                                              if (widget.onNavigateToTab != null) {
                                                widget.onNavigateToTab!(2, app['farmer']!);
                                              }
                                            },
                                            style: IconButton.styleFrom(
                                              backgroundColor: AppColors.surfaceContainerHigh,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Starting virtual consultation with ${app['farmer']}...",
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: const Color(
                                                0xFF00390E,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: const Text(
                                              "Start Call",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 80), // Extra space for floating nav bar
            ],
          ),
        ),
      ),
    );
  }
}
