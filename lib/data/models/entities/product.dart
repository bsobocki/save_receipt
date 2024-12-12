import 'package:save_receipt/data/models/entities/object.dart';

class ProductData extends ObjectData {
  final double price;
  final int receiptId;

  const ProductData({
    required super.id,
    required super.name,
    required this.price,
    required this.receiptId,
  });

  @override
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
