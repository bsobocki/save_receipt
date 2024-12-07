class ProductData {
  final int id;
  final String name;
  final double price;
  final int receiptId;

  const ProductData({
    required this.id,
    required this.name,
    required this.price,
    required this.receiptId,
  });

  ProductData copyWith({
    int? id,
    String? name,
    double? price,
    String? value,
    int? receiptId,
  }) {
    return ProductData(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      receiptId: receiptId ?? this.receiptId,
    );
  }

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $price, receiptId: $receiptId)';
}
