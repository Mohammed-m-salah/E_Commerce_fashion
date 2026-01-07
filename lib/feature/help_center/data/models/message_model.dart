enum MessageType { text, image, voice, file }

class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String message;
  final bool isAdmin;
  final bool isRead;
  final DateTime createdAt;
  final MessageType messageType;
  final String? mediaUrl;
  final String? fileName;
  final int? fileSizeBytes;
  final int? voiceDurationSeconds;
  final bool isDeleted;
  final bool isEdited;
  final DateTime? editedAt;

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    required this.isAdmin,
    required this.isRead,
    required this.createdAt,
    this.messageType = MessageType.text,
    this.mediaUrl,
    this.fileName,
    this.fileSizeBytes,
    this.voiceDurationSeconds,
    this.isDeleted = false,
    this.isEdited = false,
    this.editedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      chatRoomId: json['chat_room_id'],
      senderId: json['sender_id'],
      message: json['message'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      messageType: _parseMessageType(json['message_type']),
      mediaUrl: json['media_url'],
      fileName: json['file_name'],
      fileSizeBytes: json['file_size_bytes'],
      voiceDurationSeconds: json['voice_duration_seconds'],
      isDeleted: json['is_deleted'] ?? false,
      isEdited: json['is_edited'] ?? false,
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'])
          : null,
    );
  }

  static MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'voice':
        return MessageType.voice;
      case 'file':
        return MessageType.file;
      default:
        return MessageType.text;
    }
  }

  static String _messageTypeToString(MessageType type) {
    switch (type) {
      case MessageType.image:
        return 'image';
      case MessageType.voice:
        return 'voice';
      case MessageType.file:
        return 'file';
      default:
        return 'text';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': message,
      'is_admin': isAdmin,
      'message_type': _messageTypeToString(messageType),
      'media_url': mediaUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
      'voice_duration_seconds': voiceDurationSeconds,
    };
  }
}
