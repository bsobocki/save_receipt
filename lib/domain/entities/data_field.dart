enum ReceiptObjectModelType { object, product, info, date }

class ReceiptObjectModel {
  ReceiptObjectModelType type;
  String text;
  String? value;
  bool isEditing;

  ReceiptObjectModel({
    required this.type,
    required this.text,
    this.value,
    this.isEditing = false,
  });

  @override
  String toString() => '{$text: $value[$type|$isEditing]}';
}
