import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/data/controller/values_controller.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

import '../../helpers/comparison.dart';
import '../../helpers/expectations.dart';
import '../../helpers/test_data.dart';

void main() {
  late AllValuesModel emptyModel;
  late AllValuesModel testValuesModel;
  late AllValuesModel testValuesModelCopy;
  late Set<String> testPrices;
  late Set<String> testInfo;
  late Set<String> testTime;
  late ReceiptModel testReceiptModel;

  setUp(() {
    testPrices = {"3.21", "54,78", "1009.4"};
    emptyModel = AllValuesModel(prices: {}, info: {}, time: {});
    testInfo = {
      'Great Info!',
      'Beautifull data',
      'World Peace',
      'You are the best!'
    };
    testTime = {'2021-12-1 14:53'};
    testValuesModel = AllValuesModel(
      prices: testPrices,
      info: testInfo,
      time: testTime,
    );
    testValuesModelCopy = AllValuesModel(
      prices: testPrices.toSet(),
      info: testInfo.toSet(),
      time: testTime.toSet(),
    );
    testReceiptModel = ReceiptModel(objects: [
      ...testPrices.map((price) => produtctModel('product', price)),
      ...testInfo.map((info) => infoTextModel('info', info)),
      ...testTime.map((time) => infoTimeModel('product', time)),
    ]);
  });

  group('AllReceiptValuesController', () {
    test('create values controller for empty model', () {
      var controller = AllReceiptValuesController(model: emptyModel);
      expect(sameDataInAllValuesModels(controller.model, emptyModel), isTrue);
    });

    test('create values controller from non-empty data', () {
      var controller = AllReceiptValuesController(model: testValuesModel);
      expectTrue(sameDataInAllValuesModels(controller.model, testValuesModel));

      var controller2 = AllReceiptValuesController.fromValues(
        priceValues: testPrices.toList(),
        infoValues: testInfo.toList(),
        timeValues: testTime.toList(),
      );
      expectTrue(sameDataInAllValuesModels(controller2.model, testValuesModel));
      expectTrue(containsSameValues(controller2.model.prices, testPrices));
      expectTrue(containsSameValues(controller2.model.info, testInfo));
      expectTrue(containsSameValues(controller2.model.time, testTime));

      var controller3 =
          AllReceiptValuesController.fromReceipt(testReceiptModel);
      expectTrue(sameDataInAllValuesModels(controller3.model, testValuesModel));
      expectTrue(containsSameValues(controller3.model.prices, testPrices));
      expectTrue(containsSameValues(controller3.model.info, testInfo));
      expectTrue(containsSameValues(controller3.model.time, testTime));

      expectTrue(
          sameDataInAllValuesModels(controller.model, controller2.model));
      expectTrue(
          sameDataInAllValuesModels(controller.model, controller3.model));
    });

    test('insert values - separated copied model', () {
      var controller = AllReceiptValuesController(model: testValuesModelCopy);

      var newPrices = ['34.5', '42.00'];
      for (var price in newPrices) {
        controller.insertValue(price);
      }
      expectTrue(containsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(containsSameValues(controller.model.info, testInfo));
      expectTrue(containsSameValues(controller.model.time, testTime));

      var newInfo = ['Dzień Dobry kochani!', 'Jak się macie?'];
      for (var info in newInfo) {
        controller.insertValue(info);
      }
      expectTrue(containsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(
          containsSameValues(controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(containsSameValues(controller.model.time, testTime));

      controller.insertValue('14:12');
      expectTrue(containsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(
          containsSameValues(controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(
          containsSameValues(controller.model.time, [...testTime, '14:12']));

      controller.insertValue('13:12');
      expectTrue(containsSameValues(
          controller.model.prices, [...testPrices, ...newPrices]));
      expectTrue(
          containsSameValues(controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(containsSameValues(
          controller.model.time, [...testTime, '14:12', '13:12']));

      controller.insertValue('13.12');
      expectTrue(containsSameValues(
          controller.model.prices, [...testPrices, ...newPrices, '13.12']));
      expectTrue(
          containsSameValues(controller.model.info, [...testInfo, ...newInfo]));
      expectTrue(containsSameValues(
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

      expectTrue(containsSameValues(controller.model.prices, testPrices));
      expectTrue(containsSameValues(controller.model.info, testInfo));
      expectTrue(containsSameValues(controller.model.time, testTime));
      expectTrue(
          containsSameValues(testPrices, [...testPricesBefore, ...newPrices]));
      expectTrue(containsSameValues(testInfo, [...testInfoBefore, ...newInfo]));
      expectTrue(containsSameValues(testTime, [...testTimeBefore, ...newTime]));
    });
  });
}
