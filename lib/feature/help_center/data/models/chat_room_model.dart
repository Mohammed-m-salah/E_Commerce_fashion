class ChatRoomModel {
  final String id;
  final String userId;
  final String? adminId;
  final String status;
  final DateTime createdAt;

  ChatRoomModel({
    required this.id,
    required this.userId,
    this.adminId,
    required this.status,
    required this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      userId: json['user_id'],
      adminId: json['admin_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
