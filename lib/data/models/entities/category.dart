

// catagories for receipts and products
// receipts takes categories of its products
class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Category.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '';

  Category copyWith({
    int? id,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() =>
      'Category(id: $id, name: $name)';
}
