import 'package:save_receipt/data/models/object.dart';

class InfoData extends ObjectData {
  final String value;
  final int receiptId;

  const InfoData({
    super.id,
    required super.name,
    required this.value,
    required this.receiptId,
  });

  @override
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
