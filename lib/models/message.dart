class Message {
  final int id;
  final int itemId;
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.itemId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['message_id'] ?? 0,                       
      itemId: json['item_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': id,
      'item_id': itemId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
