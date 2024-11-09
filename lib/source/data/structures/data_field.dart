import 'package:save_receipt/source/data/structures/receipt.dart';

class DataFieldModel {
  ReceiptObjectType type;
  String text;
  String? value;
  bool isEditing;

  DataFieldModel({
    required this.type,
    required this.text,
    this.value,
    this.isEditing = false,
  });
}

class AllValuesModel {
  List<String> prices;
  List<String> info;
  List<String> dates;

  AllValuesModel({
    required this.prices,
    required this.info,
    required this.dates,
  });
}
