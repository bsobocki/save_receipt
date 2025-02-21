enum ReceiptObjectModelType {
  object,
  product,
  infoText,
  infoDouble,
  infoNumeric,
  infoTime
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

  ReceiptObjectModel.newObjectFrom(ReceiptObjectModel object, {ReceiptObjectModelType? type})
      : dataId = null,
        type = type ?? object.type,
        text = object.text,
        value = object.value;

  @override
  String toString() => '{$text: $value[$type]}';
}
