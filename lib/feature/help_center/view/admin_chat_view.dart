import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_fullapp/feature/help_center/controller/chat_controller.dart';
import 'package:e_commerce_fullapp/feature/help_center/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class AdminChatView extends StatefulWidget {
  const AdminChatView({super.key});

  @override
  State<AdminChatView> createState() => _AdminChatViewState();
}

class _AdminChatViewState extends State<AdminChatView> {
  late final ChatController _chatController;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentlyPlayingId;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    _chatController = Get.put(ChatController());
    ever(_chatController.messages, (_) => _scrollToBottom());

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _currentlyPlayingId = null;
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _chatController.sendMessage(_messageController.text);
    _messageController.clear();
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

  void _showAttachmentOptions(BuildContext context, bool isDark) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _chatController.pickImageFromGallery();
                  },
                  isDark: isDark,
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _chatController.pickImageFromCamera();
                  },
                  isDark: isDark,
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'File',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _chatController.pickFile();
                  },
                  isDark: isDark,
                ),
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const Gap(8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playVoiceMessage(String messageId, String url) async {
    try {
      if (_currentlyPlayingId == messageId && _isPlaying) {
        await _audioPlayer.pause();
      } else if (_currentlyPlayingId == messageId && !_isPlaying) {
        await _audioPlayer.resume();
      } else {
        setState(() {
          _currentlyPlayingId = messageId;
          _currentPosition = Duration.zero;
        });
        await _audioPlayer.play(UrlSource(url));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to play voice message');
    }
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFff5722)),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
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
                child: Obx(() {
                  if (_chatController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFff5722),
                      ),
                    );
                  }
                  if (_chatController.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Gap(16),
                          Text(
                            'Start a conversation with the support team',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    itemCount: _chatController.messages.length,
                    itemBuilder: (context, index) {
                      final message = _chatController.messages[index];
                      return GestureDetector(
                        onLongPress: () {
                          if (_chatController.canEditOrDeleteMessage(message)) {
                            _showMessageOptions(context, message, isDark);
                          }
                        },
                        child: _buildMessageBubble(message, isDark, theme),
                      );
                    },
                  );
                }),
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
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
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

  void _showMessageOptions(
      BuildContext context, MessageModel message, bool isDark) {
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
            if (message.messageType == MessageType.text)
              _buildOptionItem(
                icon: Icons.edit,
                label: 'تعديل الرسالة',
                onTap: () {
                  Navigator.pop(context);
                  _showEditMessageDialog(context, message, isDark);
                },
                isDark: isDark,
              ),
            _buildOptionItem(
              icon: Icons.delete,
              label: 'حذف الرسالة',
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, message, isDark);
              },
              isDark: isDark,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMessageDialog(
      BuildContext context, MessageModel message, bool isDark) {
    final editController = TextEditingController(text: message.message);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        title: Text(
          'تعديل الرسالة',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: TextField(
          controller: editController,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'أدخل الرسالة الجديدة',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _chatController.updateMessage(message.id, editController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFff5722),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'حفظ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, MessageModel message, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        title: Text(
          'حذف الرسالة',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه الرسالة؟',
          style: TextStyle(
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _chatController.deleteMessage(message.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.white),
            ),
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

  Widget _buildMessageBubble(
      MessageModel message, bool isDark, ThemeData theme) {
    final isAdmin = message.isAdmin;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
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
              padding: message.messageType == MessageType.image
                  ? const EdgeInsets.all(4)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  _buildMessageContent(message, isAdmin, isDark),
                  const Gap(4),
                  Padding(
                    padding: message.messageType == MessageType.image
                        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                        : EdgeInsets.zero,
                    child: Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        color: isAdmin
                            ? (isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade500)
                            : Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
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

  Widget _buildMessageContent(MessageModel message, bool isAdmin, bool isDark) {
    // إذا كانت الرسالة محذوفة
    if (message.isDeleted) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.block,
            size: 16,
            color: isAdmin
                ? (isDark ? Colors.grey.shade500 : Colors.grey.shade500)
                : Colors.white.withOpacity(0.7),
          ),
          const Gap(6),
          Text(
            'تم حذف هذه الرسالة',
            style: TextStyle(
              color: isAdmin
                  ? (isDark ? Colors.grey.shade500 : Colors.grey.shade500)
                  : Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      );
    }

    switch (message.messageType) {
      case MessageType.image:
        return _buildImageMessage(message, isAdmin, isDark);
      case MessageType.voice:
        return _buildVoiceMessage(message, isAdmin, isDark);
      case MessageType.file:
        return _buildFileMessage(message, isAdmin, isDark);
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isAdmin
                    ? (isDark ? Colors.white : Colors.black87)
                    : Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (message.isEdited) ...[
              const Gap(4),
              Text(
                'تم التعديل',
                style: TextStyle(
                  color: isAdmin
                      ? (isDark ? Colors.grey.shade500 : Colors.grey.shade500)
                      : Colors.white.withOpacity(0.6),
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );
    }
  }

  Widget _buildImageMessage(MessageModel message, bool isAdmin, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (message.mediaUrl != null) {
          _showImagePreview(context, message.mediaUrl!);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: message.mediaUrl != null
            ? CachedNetworkImage(
                imageUrl: message.mediaUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFff5722),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              )
            : Container(
                width: 200,
                height: 200,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildVoiceMessage(MessageModel message, bool isAdmin, bool isDark) {
    final isCurrentPlaying = _currentlyPlayingId == message.id;
    final duration = message.voiceDurationSeconds ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (message.mediaUrl != null) {
              _playVoiceMessage(message.id, message.mediaUrl!);
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isAdmin
                  ? const Color(0xFFff5722)
                  : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCurrentPlaying && _isPlaying ? Icons.pause : Icons.play_arrow,
              color: isAdmin ? Colors.white : Colors.white,
              size: 24,
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCurrentPlaying)
                LinearProgressIndicator(
                  value: _totalDuration.inSeconds > 0
                      ? _currentPosition.inSeconds / _totalDuration.inSeconds
                      : 0,
                  backgroundColor: isAdmin
                      ? Colors.grey.shade300
                      : Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isAdmin ? const Color(0xFFff5722) : Colors.white,
                  ),
                )
              else
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? Colors.grey.shade300
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              const Gap(4),
              Text(
                isCurrentPlaying
                    ? '${_formatDuration(_currentPosition)} / ${_formatDuration(Duration(seconds: duration))}'
                    : _formatDuration(Duration(seconds: duration)),
                style: TextStyle(
                  color: isAdmin
                      ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                      : Colors.white.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileMessage(MessageModel message, bool isAdmin, bool isDark) {
    final fileName = message.fileName ?? 'File';
    final fileSize = message.fileSizeBytes ?? 0;

    return GestureDetector(
      onTap: () {
        if (message.mediaUrl != null) {
          OpenFile.open(message.mediaUrl!);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isAdmin
                  ? const Color(0xFFff5722).withOpacity(0.1)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getFileIcon(fileName),
              color: isAdmin ? const Color(0xFFff5722) : Colors.white,
              size: 24,
            ),
          ),
          const Gap(12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    color: isAdmin
                        ? (isDark ? Colors.white : Colors.black87)
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(2),
                Text(
                  _formatFileSize(fileSize),
                  style: TextStyle(
                    color: isAdmin
                        ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                        : Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Icon(
            Icons.download,
            color: isAdmin
                ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                : Colors.white.withOpacity(0.7),
            size: 20,
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      case 'mp3':
      case 'wav':
      case 'm4a':
        return Icons.audio_file;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildMessageInput(bool isDark, ThemeData theme) {
    return Obx(() {
      // Show recording UI when recording
      if (_chatController.isRecording.value) {
        return _buildRecordingUI(isDark, theme);
      }

      // Show loading indicator when sending media
      if (_chatController.isSendingMedia.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFff5722),
                ),
              ),
              const Gap(12),
              Text(
                'Sending...',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      // Normal input UI
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
              onPressed: () => _showAttachmentOptions(context, isDark),
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
                      color:
                          isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            const Gap(8),
            GestureDetector(
              onTap: _messageController.text.trim().isEmpty
                  ? _chatController.startRecording
                  : _sendMessage,
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
                child: Icon(
                  _messageController.text.trim().isEmpty
                      ? Icons.mic
                      : Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRecordingUI(bool isDark, ThemeData theme) {
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
          // Cancel button
          GestureDetector(
            onTap: _chatController.cancelRecording,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
          const Gap(12),
          // Recording indicator
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(12),
                  Obx(() => Text(
                        _chatController.formatRecordingDuration(
                            _chatController.recordingDuration.value),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  const Spacer(),
                  Text(
                    'Recording...',
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(12),
          // Send button
          GestureDetector(
            onTap: _chatController.stopRecording,
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
