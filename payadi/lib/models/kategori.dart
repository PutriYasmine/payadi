class Category {
  final String? id;
  final String name;
  final String? description;
  final DateTime? createdAt;

  Category({this.id, required this.name, this.description, this.createdAt});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'name': name, 'description': description};
  }
}
