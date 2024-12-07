class InfoData {
  final int id;
  final String name;
  final String value;
  final int receiptId;

  const InfoData({
    required this.id,
    required this.name,
    required this.value,
    required this.receiptId,
  });

  InfoData copyWith({
    int? id,
    String? name,
    String? value,
    int? receiptId,
  }) {
    return InfoData(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      receiptId: receiptId ?? this.receiptId,
    );
  }

  @override
  String toString() =>
      'Product(id: $id, name: $name, value: $value, receiptId: $receiptId)';
}
