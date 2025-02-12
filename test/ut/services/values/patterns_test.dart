import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/services/values/patterns.dart';

void main() {
  setUp(() {});

  group('patterns', () {
    test('isPrice_positive', () {
      expect(isPrice('23,5'), true);
      expect(isPrice('10,9D'), true);
      expect(isPrice('42.0'), true);
      expect(isPrice('1999.00'), true);
      expect(isPrice('146.7D'), true);
      expect(isPrice('1.000*79.99 79.99A'), false);
      expect(isPrice('1.000x79.99A'), false);
      expect(isPrice('1x 32,6'), false);
      expect(isPrice('1x23,5'), false);
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

    test('hasPrice_positive', () {
      expect(hasPrice('23,5'), true);
      expect(hasPrice('10,9D'), true);
      expect(hasPrice('42.0'), true);
      expect(hasPrice('1999.00'), true);
      expect(hasPrice('146.7D'), true);
      expect(hasPrice('1.000*79.99 79.99A'), true);
      expect(hasPrice('1.000x79.99A'), true);
      expect(hasPrice('1x 32,6'), true);
      expect(hasPrice('1x23,5'), true);
      expect(hasPrice('prod 32,4D'), true);
      expect(hasPrice('adD.89.6D'), true);
      expect(hasPrice('product 1 x 78.9'), true);
      expect(hasPrice('product 1x 42,6D'), true);
      expect(hasPrice('a23,5'), true);
      expect(hasPrice('32.3.5'), true);
      expect(hasPrice('D3.5fs'), true);
      expect(hasPrice('89'), false);
      expect(hasPrice(''), false);
      expect(hasPrice('product'), false);
      expect(hasPrice('1x'), false);
      expect(hasPrice('56..8'), false);
      expect(hasPrice('257'), false);
      expect(hasPrice('84f.9'), false);
    });

    test('getAllPricesFromStr_positive', () {
      expect(getAllPricesFromStr('23,5'), ['23.5']);
      expect(getAllPricesFromStr('10,9D'), ['10.9']);
      expect(getAllPricesFromStr('42.0'), ['42.0']);
      expect(getAllPricesFromStr('1999.00'), ['1999.00']);
      expect(getAllPricesFromStr('146.7D'), ['146.7']);
      expect(getAllPricesFromStr('1.000*79.99 79.99A'), ['1.000', '79.99', '79.99']);
      expect(getAllPricesFromStr('1.000x79.99A'), ['1.000', '79.99']);
      expect(getAllPricesFromStr('1x 32,6'), ['32.6']);
      expect(getAllPricesFromStr('1x23,5'), ['23.5']);
      expect(getAllPricesFromStr('prod 32,4D'), ['32.4']);
      expect(getAllPricesFromStr('adD.89.6D'), ['89.6']);
      expect(getAllPricesFromStr('product 1 x 78.9'), ['78.9']);
      expect(getAllPricesFromStr('product 1x 42,6D'), ['42.6']);
      expect(getAllPricesFromStr('a23,5'), ['23.5']);
      expect(getAllPricesFromStr('32.3.5'), ['32.3']);
      expect(getAllPricesFromStr('D3.5fs'), ['3.5']);
      expect(getAllPricesFromStr('89'), []);
      expect(getAllPricesFromStr(''), []);
      expect(getAllPricesFromStr('product'), []);
      expect(getAllPricesFromStr('1x'), []);
      expect(getAllPricesFromStr('56..8'), []);
      expect(getAllPricesFromStr('257'), []);
      expect(getAllPricesFromStr('84f.9'), []);
      expect(getAllPricesFromStr('84.9 1.00 x'), ['84.9','1.00']);
      expect(getAllPricesFromStr('ad 32.9*84.9 1.00x'), ['32.9', '84.9', '1.00']);
      expect(getAllPricesFromStr('ad 32.9*84.9 100x'), ['32.9', '84.9']);
    });

    test('isProductWithPrice', () {
      expect(isProductWithPrice(' WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
          true);
      expect(isProductWithPrice('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
          true);
      expect(
          isProductWithPrice('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A'), true);
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
