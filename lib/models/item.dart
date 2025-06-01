class Item {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String category;
  final String status;
  final String posterName;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.posterName,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
  return Item(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    category: json['category'] ?? '',
    status: json['status'] ?? '',
    posterName: json['name'] ?? '', 
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
  );
}


 Map<String, dynamic> toJson() {
  return {
    'id': id, 
    'user_id': userId,
    'title': title,
    'description': description,
    'category': category,
    'status': status,
    'poster_name': posterName,
    'created_at': createdAt.toIso8601String(),
  };
}

} 