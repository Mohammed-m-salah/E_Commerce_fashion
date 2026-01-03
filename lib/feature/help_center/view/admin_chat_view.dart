import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdminChatView extends StatefulWidget {
  const AdminChatView({super.key});

  @override
  State<AdminChatView> createState() => _AdminChatViewState();
}

class _AdminChatViewState extends State<AdminChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! Welcome to our support. How can I help you today?",
      isAdmin: true,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text.trim(),
        isAdmin: false,
        time: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate admin response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "Thank you for your message. Our team will respond shortly.",
            isAdmin: true,
            time: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isDark, theme),

            // Chat Messages
            Expanded(
              child: Container(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(
                      _messages[index],
                      isDark,
                      theme,
                    );
                  },
                ),
              ),
            ),

            // Message Input
            _buildMessageInput(isDark, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFff5722), Color(0xFFff8a65)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Team',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const Gap(2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              _showOptionsMenu(context, isDark);
            },
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(20),
            _buildOptionItem(
              icon: Icons.delete_outline,
              label: 'Clear Chat',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                  _messages.add(ChatMessage(
                    text: "Hello! Welcome to our support. How can I help you today?",
                    isAdmin: true,
                    time: DateTime.now(),
                  ));
                });
              },
              isDark: isDark,
            ),
            _buildOptionItem(
              icon: Icons.info_outline,
              label: 'Chat Info',
              onTap: () => Navigator.pop(context),
              isDark: isDark,
            ),
            _buildOptionItem(
              icon: Icons.block,
              label: 'Report Issue',
              onTap: () => Navigator.pop(context),
              isDark: isDark,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : isDark
                ? Colors.white
                : Colors.black87,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive
              ? Colors.red
              : isDark
                  ? Colors.white
                  : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDark, ThemeData theme) {
    final isAdmin = message.isAdmin;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isAdmin) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFff5722), Color(0xFFff8a65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 18,
              ),
            ),
            const Gap(8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isAdmin
                    ? (isDark ? Colors.grey.shade800 : Colors.white)
                    : const Color(0xFFff5722),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isAdmin ? 4 : 16),
                  bottomRight: Radius.circular(isAdmin ? 16 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isAdmin
                          ? (isDark ? Colors.white : Colors.black87)
                          : Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      color: isAdmin
                          ? (isDark ? Colors.grey.shade500 : Colors.grey.shade500)
                          : Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isAdmin) ...[
            const Gap(8),
            Icon(
              Icons.done_all,
              size: 16,
              color: Colors.blue.shade400,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildMessageInput(bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFff5722), Color(0xFFff8a65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isAdmin;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isAdmin,
    required this.time,
  });
}
