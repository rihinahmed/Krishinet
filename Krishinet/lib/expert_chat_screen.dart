import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:krishinet/core/utils/constants.dart';

class FarmerChat {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final bool isOnline;
  final bool isUrgent;
  final String cropContext;
  final List<ChatMessage> messages;
  final String role;

  FarmerChat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    required this.isOnline,
    required this.isUrgent,
    required this.cropContext,
    required this.messages,
    required this.role,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.imagePath,
  });
}

class ExpertChatScreen extends StatefulWidget {
  final bool isEmbedded;
  final String? initialChatId;
  final String? initialFarmerName;
  const ExpertChatScreen({
    super.key,
    this.isEmbedded = false,
    this.initialChatId,
    this.initialFarmerName,
  });

  // Global static list of chat rooms to persist message history across tab transitions
  static List<FarmerChat>? _globalChatRooms;
  static List<FarmerChat> get chatRooms {
    _globalChatRooms ??= [
        FarmerChat(
          id: '1',
          name: 'Selim Rahman',
          lastMessage:
              'The yellow spots are spreading to lower leaves. What should I spray?',
          time: 'Typing...',
          imageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
          isOnline: true,
          isUrgent: true,
          cropContext: 'Wheat • North Acre Area',
          role: 'farmer',
          messages: [
            ChatMessage(
              text: "Hello Doctor, I recently uploaded soil reports.",
              isMe: false,
              time: DateTime.now().subtract(const Duration(minutes: 20)),
            ),
            ChatMessage(
              text:
                  "Thanks Selim, I reviewed the report. Nitrogen is slightly low, but the visual leaf symptoms look like early-stage Rust disease.",
              isMe: true,
              time: DateTime.now().subtract(const Duration(minutes: 15)),
            ),
            ChatMessage(
              text:
                  "The yellow spots are spreading to lower leaves. What should I spray?",
              isMe: false,
              time: DateTime.now().subtract(const Duration(minutes: 2)),
            ),
          ],
        ),
        FarmerChat(
          id: '2',
          name: 'Mina Khatun',
          lastMessage:
              'Organic manure options list has been submitted for subsidy.',
          time: '2m ago',
          imageUrl:
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=150&q=80',
          isOnline: false,
          isUrgent: false,
          cropContext: 'Paddy • South Block',
          role: 'buyer',
          messages: [
            ChatMessage(
              text: "Can I use compost manure instead of chemical fertilizer?",
              isMe: false,
              time: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            ChatMessage(
              text:
                  "Absolutely, compost is highly recommended for Clayey paddy soil. I will provide the list.",
              isMe: true,
              time: DateTime.now().subtract(const Duration(hours: 1)),
            ),
            ChatMessage(
              text: "Organic manure options list has been submitted for subsidy.",
              isMe: false,
              time: DateTime.now().subtract(const Duration(minutes: 2)),
            ),
          ],
        ),
        FarmerChat(
          id: '3',
          name: 'Kabir Uddin',
          lastMessage: 'Ok thanks, I will discuss this with the local Officer.',
          time: '15m ago',
          imageUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
          isOnline: true,
          isUrgent: false,
          cropContext: 'Mustard • West Block',
          role: 'govt',
          messages: [
            ChatMessage(
              text: "Do we have any intercropping circular benefits?",
              isMe: false,
              time: DateTime.now().subtract(const Duration(hours: 4)),
            ),
            ChatMessage(
              text:
                  "Yes, mustard intercropped with wheat provides pest insulation. Circular benefits are available.",
              isMe: true,
              time: DateTime.now().subtract(const Duration(hours: 3)),
            ),
            ChatMessage(
              text: "Ok thanks, I will discuss this with the local Officer.",
              isMe: false,
              time: DateTime.now().subtract(const Duration(minutes: 15)),
            ),
          ],
        ),
      ];
    return _globalChatRooms!;
  }

  @override
  State<ExpertChatScreen> createState() => _ExpertChatScreenState();
}

class _ExpertChatScreenState extends State<ExpertChatScreen> {
  // Theme Colors
  final Color background = const Color(0xFF051424);
  final Color surfaceContainer = const Color(0xFF122131);
  final Color surfaceContainerHigh = const Color(0xFF1C2B3C);
  final Color surfaceContainerHighest = const Color(0xFF273647);
  final Color primary = const Color(0xFF54E167);
  final Color primaryContainer = const Color(0xFF2CC04B);
  final Color onBackground = const Color(0xFFD4E4FA);
  final Color onSurfaceVariant = const Color(0xFFBCCBB7);
  final Color glassBackground = const Color(0xB3122131);
  final Color glassBorder = const Color(0x0DFFFFFF);

  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  FarmerChat? _selectedChat;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _handleInitialRedirection();
  }

  @override
  void didUpdateWidget(covariant ExpertChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleInitialRedirection();
  }

  void _handleInitialRedirection() {
    if (widget.initialFarmerName != null) {
      final name = widget.initialFarmerName!;
      final idx = ExpertChatScreen.chatRooms.indexWhere(
        (element) => element.name.toLowerCase() == name.toLowerCase(),
      );
      if (idx != -1) {
        _selectedChat = ExpertChatScreen.chatRooms[idx];
      } else {
        // Create new dynamic chat room matching farmer details
        final newRoom = FarmerChat(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          lastMessage: 'Consultation chat initialized.',
          time: 'Just now',
          imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
          isOnline: true,
          isUrgent: false,
          cropContext: 'Consultation • Active Session',
          role: 'farmer',
          messages: [
            ChatMessage(
              text: "Hi Doctor, I clicked Message from our consultation booking.",
              isMe: false,
              time: DateTime.now(),
            ),
          ],
        );
        ExpertChatScreen.chatRooms.add(newRoom);
        _selectedChat = newRoom;
      }
      _scrollToBottom();
    } else if (widget.initialChatId != null) {
      final idx = ExpertChatScreen.chatRooms.indexWhere(
        (element) => element.id == widget.initialChatId,
      );
      if (idx != -1) {
        _selectedChat = ExpertChatScreen.chatRooms[idx];
      }
      _scrollToBottom();
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty || _selectedChat == null) return;

    setState(() {
      _selectedChat!.messages.add(
        ChatMessage(text: text, isMe: true, time: DateTime.now()),
      );
      _msgController.clear();
    });

    _scrollToBottom();

    // Setup simulated replies representing crop advisor expert tips
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted || _selectedChat == null) return;
      String replyText =
          "Understood. I recommend applying a copper-based fungicide (like Blitox 50g in 15L water) or bio-agents. Let me verify soil humidity ranges first.";
      if (_selectedChat!.name.contains("Mina")) {
        replyText =
            "Circular approval is pending from District HQ. I will keep you posted.";
      } else if (_selectedChat!.name.contains("Kabir")) {
        replyText =
            "Make sure seed spacing is 30x10 cm for mustard to achieve the best results.";
      }

      setState(() {
        _selectedChat!.messages.add(
          ChatMessage(text: replyText, isMe: false, time: DateTime.now()),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void _showImageUploadDialog() {
    final List<String> cropImages = [
      'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1463123081488-729f555e3f7b?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1595974482597-4b8da8879bc5?auto=format&fit=crop&w=800&q=80',
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF122131),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upload Diagnostic Image",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Choose standard diagnostic photo preset:",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cropImages.length,
                  itemBuilder: (context, index) {
                    final imgUrl = cropImages[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedChat!.messages.add(
                            ChatMessage(
                              text: "Advisory photo attachment sent.",
                              isMe: true,
                              time: DateTime.now(),
                              imagePath: imgUrl,
                            ),
                          );
                        });
                        Navigator.pop(context);
                        _scrollToBottom();
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(imgUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Or enter custom image URL:",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    setState(() {
                      _selectedChat!.messages.add(
                        ChatMessage(
                          text: "Advisory photo attachment sent.",
                          isMe: true,
                          time: DateTime.now(),
                          imagePath: val.trim(),
                        ),
                      );
                    });
                    Navigator.pop(context);
                    _scrollToBottom();
                  }
                },
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: "https://example.com/crop.jpg",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF54E167))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChat != null) {
      return _buildChatThreadView();
    }

    return _buildChatRoomsListView();
  }

  Widget _buildChatRoomsListView() {
    final filteredRooms =
        ExpertChatScreen.chatRooms.where((room) {
          final matchesSearch =
              room.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              room.cropContext.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          return matchesSearch;
        }).toList();

    Widget body = Column(
      children: [
        if (widget.isEmbedded) _buildHeaderBar(),
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(color: onBackground, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search chats or crops...',
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
          child:
              filteredRooms.isEmpty
                  ? Center(
                    child: Text(
                      'No active chats found.',
                      style: TextStyle(color: onSurfaceVariant),
                    ),
                  )
                  : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];
                      return _buildChatRoomCard(room);
                    },
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
            'Farmer Consultations',
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

  Widget _buildChatRoomCard(FarmerChat room) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _buildGlassCard(
        onTap: () {
          setState(() {
            _selectedChat = room;
          });
          _scrollToBottom();
        },
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AppConstants.buildImageProvider(room.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (room.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: surfaceContainer, width: 2),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        room.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: room.isUrgent ? primary : onSurfaceVariant,
                          fontWeight:
                              room.isUrgent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.cropContext,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildChatThreadView() {
    if (_selectedChat == null) return const SizedBox();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surfaceContainer,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _selectedChat = null;
            });
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AppConstants.buildImageProvider(_selectedChat!.imageUrl),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedChat!.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _selectedChat!.cropContext,
                    style: TextStyle(fontSize: 11, color: primary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.verified_user, color: primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: _selectedChat!.messages.length,
                itemBuilder: (context, index) {
                  final msg = _selectedChat!.messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // Chat input
            _buildChatInputBar(),
            if (widget.isEmbedded) const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                msg.isMe
                    ? primary.withValues(alpha: 0.15)
                    : surfaceContainerHigh,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: msg.isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: msg.isMe ? Radius.zero : const Radius.circular(16),
            ),
            border: Border.all(
              color: msg.isMe ? primary.withValues(alpha: 0.25) : glassBorder,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppConstants.buildNetworkImage(
                    context: context,
                    url: msg.imagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                msg.text,
                style: TextStyle(fontSize: 14, color: onBackground, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceContainer,
        border: Border(top: BorderSide(color: glassBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: primary),
            onPressed: _showImageUploadDialog,
            tooltip: "Add Image Attachment",
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _msgController,
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(color: onBackground, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Type guidance response...',
                hintStyle: TextStyle(
                  color: onSurfaceVariant.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, VoidCallback? onTap}) {
    final body = ClipRRect(
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

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: primary.withValues(alpha: 0.1),
          highlightColor: primary.withValues(alpha: 0.05),
          child: body,
        ),
      );
    }
    return body;
  }
}
