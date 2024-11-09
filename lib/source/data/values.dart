

import 'package:save_receipt/source/data/parse_data.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';

void insertValue(String value, AllValuesModel model) {
  if (isPrice(value)) {
    model.prices.add(value);
  } else if (isDate(value)) {
    model.dates.add(value);
  } else {
    model.info.add(value);
  }
}