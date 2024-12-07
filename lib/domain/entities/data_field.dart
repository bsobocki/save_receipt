import 'package:save_receipt/domain/entities/receipt.dart';

class DataFieldModel {
  ReceiptModelObjectType type;
  String text;
  String? value;
  bool isEditing;

  DataFieldModel({
    required this.type,
    required this.text,
    this.value,
    this.isEditing = false,
  });

  @override
  String toString() => '{$text: $value[$type|$isEditing]}';
}
