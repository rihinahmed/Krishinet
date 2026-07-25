import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/post_service.dart';
import '../core/utils/constants.dart';

// Reusable custom GlassCard matching dashboard specs
class FeedGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const FeedGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xB3122131), // glassBackground
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0x0DFFFFFF), width: 1), // glassBorder
      ),
      child: child,
    );

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
          splashColor: const Color(0xFF54E167).withValues(alpha: 0.1),
          highlightColor: const Color(0xFF54E167).withValues(alpha: 0.05),
          child: cardContent,
        ),
      );
    }
    return cardContent;
  }
}

class KnowledgeBaseSection extends StatefulWidget {
  final String role; // 'expert', 'farmer', or 'govt'

  const KnowledgeBaseSection({
    super.key,
    required this.role,
  });

  @override
  State<KnowledgeBaseSection> createState() => _KnowledgeBaseSectionState();
}

class _KnowledgeBaseSectionState extends State<KnowledgeBaseSection> {
  final _postCtrl = TextEditingController();
  String? _selectedPresetUrl;

  final List<String> _presets = [
    'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?auto=format&fit=crop&w=800&q=80', // Green Wheat Field
    'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?auto=format&fit=crop&w=800&q=80', // Sprouts
    'https://images.unsplash.com/photo-1463123081488-729f555e3f7b?auto=format&fit=crop&w=800&q=80', // Soil/Fertilizer
    'https://images.unsplash.com/photo-1595974482597-4b8da8879bc5?auto=format&fit=crop&w=800&q=80', // Harvesting
    'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?auto=format&fit=crop&w=800&q=80', // Greenhouse
  ];

  void _submitPost() {
    final text = _postCtrl.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write some suggestion content first."),
          backgroundColor: Color(0xFFFFB4AB),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      PostService.addPost(text, _selectedPresetUrl);
      _postCtrl.clear();
      _selectedPresetUrl = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Agri suggestion posted successfully to feed!"),
        backgroundColor: Color(0xFF54E167),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _postCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Agri Suggestions Feed",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4E4FA), // AppColors.onBackground
              ),
            ),
            if (widget.role == 'expert')
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Manage Feed',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF54E167), // AppColors.primary
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Composer Card (Visible to Agri-Experts only)
        if (widget.role == 'expert') ...[
          FeedGlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF1C2B3C),
                      backgroundImage: AppConstants.buildImageProvider(
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _postCtrl,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Share an agricultural suggestion / crop advisory...",
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),
                
                // Image Selector Layout
                const Text(
                  "Attach Photo (Select Preset):",
                  style: TextStyle(
                    color: Color(0xFFBCCBB7),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _presets.length,
                    itemBuilder: (context, index) {
                      final url = _presets[index];
                      final isSelected = _selectedPresetUrl == url;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedPresetUrl = null;
                            } else {
                              _selectedPresetUrl = url;
                            }
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF54E167) : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AppConstants.buildNetworkImage(
                              context: context,
                              url: url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, e, s) => Container(color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Post Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitPost,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text(
                      "Post Suggestion",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54E167),
                      foregroundColor: const Color(0xFF00390E),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Suggestions List (Readable by all roles)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: PostService.posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final post = PostService.posts[index];
            return FeedGlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Header (Author details)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFF1C2B3C),
                          backgroundImage: AppConstants.buildImageProvider(
                            'https://images.unsplash.com/photo-1542909168-82c3e7fdca5c?auto=format&fit=crop&w=150&q=80', // General avatar placeholder
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.authorName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${post.authorTitle} • ${post.date}",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: const Color(0xFFBCCBB7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Post Text Body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      post.content,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: const Color(0xFFD4E4FA),
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Attached Image
                  if (post.imagePath != null)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 250),
                      width: double.infinity,
                      child: AppConstants.buildNetworkImage(
                        context: context,
                        url: post.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          color: const Color(0xFF122131),
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                  const Divider(color: Colors.white10, height: 1),

                  // Interaction Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        // Facebook-like Like button
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              post.isLikedByMe = !post.isLikedByMe;
                              if (post.isLikedByMe) {
                                post.likes++;
                              } else {
                                post.likes--;
                              }
                            });
                          },
                          icon: Icon(
                            post.isLikedByMe ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                            size: 16,
                            color: post.isLikedByMe ? const Color(0xFF54E167) : Colors.white60,
                          ),
                          label: Text(
                            "${post.likes} Likes",
                            style: TextStyle(
                              fontSize: 12,
                              color: post.isLikedByMe ? const Color(0xFF54E167) : Colors.white60,
                              fontWeight: post.isLikedByMe ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Row(
                          children: [
                            Icon(Icons.share, size: 16, color: Colors.white60),
                            SizedBox(width: 4),
                            Text("Share", style: TextStyle(fontSize: 12, color: Colors.white60)),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
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
