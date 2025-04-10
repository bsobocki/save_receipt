import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_model_controller.dart';

import '../../helpers/comparison.dart';

void main() {
  setUp(() {});

  group('ReceiptModelController', () {
    test('create model controller for empty data', () {
      ReceiptModel model = const ReceiptModel(title: '', objects: []);
      ReceiptModelController controller =
          ReceiptModelController(receipt: model);
      expect(sameDataInReceiptModels(controller.model, model), isTrue);
    });

    test('', (){});
  });
}
