import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/services/values/patterns.dart';

class AllReceiptValuesController {
  final AllValuesModel model;

  AllReceiptValuesController.fromValues(
      {required Iterable<String> priceValues,
      required Iterable<String> infoValues,
      required Iterable<String> timeValues})
      : model = AllValuesModel(
            prices: priceValues.toSet(), info: infoValues.toSet(), time: timeValues.toSet());

  AllReceiptValuesController({required this.model});

  AllReceiptValuesController.fromReceipt(ReceiptModel receipt)
      : model = AllValuesModel(
            prices: receipt.prices.toSet(),
            info: receipt.infoStr.toSet(),
            time: receipt.timeStr.toSet());

  void insertValue(String value) {
    if (isPrice(value)) {
      model.prices.add(value);
    } else if (isTime(value)) {
      model.time.add(value);
    } else {
      model.info.add(value);
    }
  }

  void removeValue(String value) {
    if (isPrice(value)) {
      model.prices.remove(value);
    } else if (isTime(value)) {
      model.time.remove(value);
    } else {
      model.info.remove(value);
    }
  }
}
