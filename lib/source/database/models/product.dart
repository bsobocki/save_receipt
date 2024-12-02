

class Product {
  final int id;
  final String name;
  final double price;
  final double quantity;
  final int receiptId;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.receiptId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'receipt_id': receiptId,
    };
  }

  Product.fromMap(Map<String, dynamic> map):
    id = map['id'] ?? -1,
    name = map['name'] ?? '',
    price = map['price'] ?? 0.0,
    quantity = map['quantity'] ?? 0,
    receiptId = map['receipt_id'] ?? -1;
  
  Product copyWith({
    int? id,
    String? name,
    double? price,
    double? quantity,
    int? receiptId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      receiptId: receiptId ?? this.receiptId,
    );
  }

  @override
  String toString() => 
    'Product(id: $id, name: $name, price: $price, quantity: $quantity, receiptId: $receiptId)';
}
