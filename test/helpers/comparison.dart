import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

bool receiptObjectModelsHasTheSameData(
    ReceiptObjectModel m1, ReceiptObjectModel m2) {
  return m1.dataId == m2.dataId &&
      m1.type == m2.type &&
      m1.text == m2.text &&
      m1.value == m2.value;
}

bool listsContainsSameValues<T>(List<T> l1, List<T> l2,
    {bool Function(T, T)? areTheSame}) {
  if (l1.length != l2.length) return false;

  var list1 = l1.toList()..sort();
  var list2 = l2.toList()..sort();

  bool Function(T, T) sameData = areTheSame ?? (T a, T b) => a == b;

  for (int i = 0; i < l1.length; i++) {
    if (!sameData(list1[i], list2[i])) {
      return false;
    }
  }

  return true;
}

bool sameDataInReceiptModels(ReceiptModel a, ReceiptModel b) {
  List<ReceiptObjectModel> objectsA = a.objects.toList()..sort();
  List<ReceiptObjectModel> objectsB = b.objects.toList()..sort();
  return a.imgPath == b.imgPath &&
      listsContainsSameValues(objectsA, objectsB,
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
  return listsContainsSameValues(pricesA, pricesB) &&
      listsContainsSameValues(infoA, infoB) &&
      listsContainsSameValues(timeA, timeB);
}
