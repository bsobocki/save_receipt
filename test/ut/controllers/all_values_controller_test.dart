import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/data/controller/values_controller.dart';
import 'package:save_receipt/domain/entities/all_values.dart';

import '../../helpers/comparison.dart';

void main() {
  late AllValuesModel emptyModel;
  late AllValuesModel testValuesModel;
  late List<String> testPrices;
  late List<String> testInfo;
  late List<String> testTime;

  setUp(() {
    testPrices = ["3.21", "54,78", "1009.4"];
    emptyModel = AllValuesModel(prices: [], info: [], time: []);
    testInfo = [
      'Great Info!',
      'Beautifull data',
      'World Peace',
      'You are the best!'
    ];
    testTime = ['2021-12-1 14:53'];
    testValuesModel =
        AllValuesModel(prices: testPrices, info: testInfo, time: testTime);
  });

  group('AllReceiptValuesController', () {
    test('create values controller for empty model', () {
      var controller = AllReceiptValuesController(model: emptyModel);
      expect(sameDataInAllValuesModels(controller.model, emptyModel), isTrue);
    });

    test('create values controller from non-empty data', () {
      var controller = AllReceiptValuesController(model: testValuesModel);
      expect(sameDataInAllValuesModels(controller.model, testValuesModel), isTrue);
    });
  });
}
