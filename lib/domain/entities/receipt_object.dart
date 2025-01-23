enum ReceiptObjectModelType {
  object,
  product,
  infoText,
  infoDouble,
  infoNumeric,
  infoDate
}

class ReceiptObjectModel {
  final int? dataId;
  ReceiptObjectModelType type;
  String text;
  String? value;

  ReceiptObjectModel({
    this.dataId,
    required this.type,
    required this.text,
    this.value,
  });

  @override
  String toString() => '{$text: $value[$type]}';
}
