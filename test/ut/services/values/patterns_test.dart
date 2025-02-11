import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/services/values/patterns.dart';

void main() {
  setUp(() {});

  group('patterns', () {
    test('isPrice_positive', () {
      expect(isPrice('23,5'), true);
      expect(isPrice('10,9D'), true);
      expect(isPrice('1x23,5'), true);
      expect(isPrice('1x 32,6'), true);
      expect(isPrice('42.0'), true);
      expect(isPrice('1999.00'), true);
      expect(isPrice('146.7D'), true);
      expect(isPrice('prod 32,4D'), false);
      expect(isPrice('adD.89.6D'), false);
      expect(isPrice('product 1 x 78.9'), false);
      expect(isPrice('product 1x 42,6D'), false);
      expect(isPrice('a23,5'), false);
      expect(isPrice('89'), false);
      expect(isPrice(''), false);
      expect(isPrice('product'), false);
      expect(isPrice('1x'), false);
      expect(isPrice('56..8'), false);
      expect(isPrice('32.3.5'), false);
      expect(isPrice('257'), false);
      expect(isPrice('D3.5fs'), false);
      expect(isPrice('84f.9'), false);
    });

    test('isProductWithPrice', () {
      expect(isProductWithPrice(' WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '), true);
      expect(isProductWithPrice('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '), true);
      expect(isProductWithPrice('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A'), true);
      expect(isProductWithPrice('product 1x 42,6D'), true);
      expect(isProductWithPrice('product 1 x 78.9'), true);
      expect(isProductWithPrice('product 1x78.9'), true);
      expect(isProductWithPrice('product1x78.9D'), true);
      expect(isProductWithPrice('p 78.9'), true);
      expect(isProductWithPrice('product 42,6D'), true);
      expect(isProductWithPrice('prod78.9'), true);
      expect(isProductWithPrice('p78.9AC'), true);
      expect(isProductWithPrice('42,6D'), false);
      expect(isProductWithPrice('product1x789'), false);
    });
  });
}
