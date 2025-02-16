import 'package:save_receipt/domain/entities/receipt.dart';

class TestData {}

ReceiptObjectModel produtctModel(String text, String price) {
  return ReceiptObjectModel(
    type: ReceiptObjectModelType.product,
    text: text,
    value: price,
  );
}

ReceiptObjectModel infoDoubleModel(String text, String price) {
  return ReceiptObjectModel(
    type: ReceiptObjectModelType.infoDouble,
    text: text,
    value: price,
  );
}

ReceiptObjectModel infoTextModel(String text, String value) {
  return ReceiptObjectModel(
    type: ReceiptObjectModelType.infoText,
    text: text,
    value: value,
  );
}

ReceiptObjectModel infoTimeModel(String text, String value) {
  return ReceiptObjectModel(
    type: ReceiptObjectModelType.infoTime,
    text: text,
    value: value,
  );
}
