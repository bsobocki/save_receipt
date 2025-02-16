import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

bool receiptObjectModelsHasTheSameData(
    ReceiptObjectModel m1, ReceiptObjectModel m2) {
  return m1.dataId == m2.dataId &&
      m1.type == m2.type &&
      m1.text == m2.text &&
      m1.value == m2.value;
}

bool containsSameValues<T>(Iterable<T> i1, Iterable<T> i2,
    {bool Function(T, T)? areTheSame}) {
  if (i1.length != i2.length) return false;
  bool Function(T, T) sameData = areTheSame ?? (T a, T b) => a == b;

  Map<T, int> count1 = HashMap(equals: sameData);
  Map<T, int> count2 = HashMap(equals: sameData);

  for (T elem in i1) {
    count1[elem] = (count1[elem] ?? 0) + 1;
  }
  for (T elem in i2) {
    count2[elem] = (count2[elem] ?? 0) + 1;
  }

  return mapEquals(count1, count2);
}

bool sameDataInReceiptModels(ReceiptModel a, ReceiptModel b) {
  List<ReceiptObjectModel> objectsA = a.objects.toList()..sort();
  List<ReceiptObjectModel> objectsB = b.objects.toList()..sort();
  return a.imgPath == b.imgPath &&
      containsSameValues(objectsA, objectsB,
          areTheSame: receiptObjectModelsHasTheSameData) &&
      a.receiptId == b.receiptId;
}

bool sameDataInAllValuesModels(AllValuesModel a, AllValuesModel b) {
  List<String> pricesA = a.prices.toList()..sort();
  List<String> pricesB = b.prices.toList()..sort();
  List<String> infoA = a.info.toList()..sort();
  List<String> infoB = b.info.toList()..sort();
  List<String> timeA = a.time.toList()..sort();
  List<String> timeB = b.time.toList()..sort();
  return containsSameValues(pricesA, pricesB) &&
      containsSameValues(infoA, infoB) &&
      containsSameValues(timeA, timeB);
}
