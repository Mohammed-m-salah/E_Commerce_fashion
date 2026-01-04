class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String message;
  final bool isAdmin;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    required this.isAdmin,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      chatRoomId: json['chat_room_id'],
      senderId: json['sender_id'],
      message: json['message'],
      isAdmin: json['is_admin'] ?? false,
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': message,
      'is_admin': isAdmin,
    };
  }
}
