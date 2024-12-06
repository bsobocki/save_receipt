class ShopData {
  final int id;
  final String name;

  ShopData({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  ShopData.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '';

  ShopData copyWith({
    int? id,
    String? name,
  }) {
    return ShopData(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() =>
      'Shop(id: $id, name: $name)';
}
