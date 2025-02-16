import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/data/controller/values_controller.dart';
import 'package:save_receipt/domain/entities/all_values.dart';

import '../../helpers/comparison.dart';
import '../../helpers/expectations.dart';

void main() {
  late AllValuesModel emptyModel;
  late AllValuesModel testValuesModel;
  late AllValuesModel testValuesModelCopy;
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
    testValuesModelCopy = AllValuesModel(
        prices: testPrices.toList(),
        info: testInfo.toList(),
        time: testTime.toList());
  });

  group('AllReceiptValuesController', () {
    test('create values controller for empty model', () {
      var controller = AllReceiptValuesController(model: emptyModel);
      expect(sameDataInAllValuesModels(controller.model, emptyModel), isTrue);
    });

    test('create values controller from non-empty data', () {
      var controller = AllReceiptValuesController(model: testValuesModel);
      expect(
          sameDataInAllValuesModels(controller.model, testValuesModel), isTrue);
    });

    test('insert values - separated copied model', () {
      var controller = AllReceiptValuesController(model: testValuesModelCopy);

      var newPrices = ['34.5', '42.00'];
      for (var price in newPrices) {
        controller.insertValue(price);
      }
      expectTrue(listsContainsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(listsContainsSameValues(controller.model.info, testInfo));
      expectTrue(listsContainsSameValues(controller.model.time, testTime));

      var newInfo = ['Dzień Dobry kochani!', 'Jak się macie?'];
      for (var info in newInfo) {
        controller.insertValue(info);
      }
      expectTrue(listsContainsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(listsContainsSameValues(
          controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(listsContainsSameValues(controller.model.time, testTime));

      controller.insertValue('14:12');
      expectTrue(listsContainsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(listsContainsSameValues(
          controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(listsContainsSameValues(
          controller.model.time, [...testTime, '14:12']));

      controller.insertValue('13:12');
      expectTrue(listsContainsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(listsContainsSameValues(
          controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(listsContainsSameValues(
          controller.model.time, [...testTime, '14:12', '13:12']));

      controller.insertValue('13.12');
      expectTrue(listsContainsSameValues(
          controller.model.prices, [...testPrices, ...newPrices, '13.12']));
      expectTrue(listsContainsSameValues(
          controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(listsContainsSameValues(
          controller.model.time, [...testTime, '14:12', '13:12']));
    });

    test('insert values using referenced lists - original passed object', () {
      var newPrices = ['34.5', '42.00'];
      var newInfo = ['Dzień Dobry kochani!', 'Jak się macie?'];
      var newTime = ['13:12', '2024-12-12', '4.12.1997 15:12'];

      var testPricesBefore = testPrices.toList();
      var testInfoBefore = testInfo.toList();
      var testTimeBefore = testTime.toList();

      var controller = AllReceiptValuesController(model: testValuesModel);

      for (var price in newPrices) {
        controller.insertValue(price);
      }
      for (var info in newInfo) {
        controller.insertValue(info);
      }
      for (var time in newTime) {
        controller.insertValue(time);
      }

      expectTrue(listsContainsSameValues(controller.model.prices, testPrices));
      expectTrue(listsContainsSameValues(controller.model.info, testInfo));
      expectTrue(listsContainsSameValues(controller.model.time, testTime));
      expectTrue(listsContainsSameValues(
          testPrices, [...testPricesBefore, ...newPrices]));
      expectTrue(listsContainsSameValues(
          testInfo, [...testInfoBefore, ...newInfo]));
      expectTrue(listsContainsSameValues(
          testTime, [...testTimeBefore, ...newTime]));
    });
  });
}
