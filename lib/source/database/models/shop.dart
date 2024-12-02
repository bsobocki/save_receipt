class Shop {
  final int id;
  final String name;

  Shop({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Shop.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '';

  Shop copyWith({
    int? id,
    String? name,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() =>
      'Shop(id: $id, name: $name)';
}
