import 'package:flutter_test/flutter_test.dart';
import 'package:save_receipt/services/values/patterns.dart';

void main() {
  setUp(() {});

  group('patterns', () {
    test('isPrice', () {
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

    test('hasPrice', () {
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

    test('getPriceStr', () {
      expect(getPriceStr('23,5'), '23.5');
      expect(getPriceStr('10,9D'), '10.9');
      expect(getPriceStr('42.0'), '42.0');
      expect(getPriceStr('1999.00'), '1999.00');
      expect(getPriceStr('146.7D'), '146.7');
      expect(getPriceStr('1.000*79.99 79.99A'),
          '79.99',);
      expect(getPriceStr('1.000x79.99A'), '79.99');
      expect(getPriceStr('1x 32,6'), '32.6');
      expect(getPriceStr('1x23,5'), '23.5');
      expect(getPriceStr('prod 32,4D'), '32.4');
      expect(getPriceStr('adD.89.6D'), '89.6');
      expect(getPriceStr('product 1 x 78.9'), '78.9');
      expect(getPriceStr('product 1x 42,6D'), '42.6');
      expect(getPriceStr('a23,5'), '23.5');
      expect(getPriceStr('32.3.5'), '32.3');
      expect(getPriceStr('D3.5fs'), '3.5');
      expect(getPriceStr('89'), '');
      expect(getPriceStr(''), '');
      expect(getPriceStr('product'), '');
      expect(getPriceStr('1x'), '');
      expect(getPriceStr('56..8'), '');
      expect(getPriceStr('257'), '');
      expect(getPriceStr('84f.9'), '');
      expect(getPriceStr('84.9 1.00 x'), '1.00');
      expect(getPriceStr('product 1x 42,6D'), '42.6');
      expect(getPriceStr('product 1 x 78.9'), '78.9');
      expect(getPriceStr('product 1x78.9'), '78.9');
      expect(getPriceStr('product1x78.9D'), '78.9');
      expect(getPriceStr('p 78.9'), '78.9');
      expect(getPriceStr('product 42,6D'), '42.6');
      expect(getPriceStr('prod78.9'), '78.9');
      expect(getPriceStr('p78.9AC'), '78.9');
      expect(getPriceStr('42,6D'), '42.6');
      expect(getPriceStr('ad 32.9*84.9 100x'), '84.9');
      expect(getPriceStr('product1x789'), '');
      expect(
        getPriceStr('ad 32.9*84.9 1.00x'),
        '1.00',
      );
      expect(
        getPriceStr(' WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
        '79.99',
      );
      expect(
        getPriceStr('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
        '79.99',
      );
      expect(
        getPriceStr('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A'),
        '79.99',
      );
    });

    test('getAllPricesFromStr', () {
      expect(getAllPricesFromStr('23,5'), ['23.5']);
      expect(getAllPricesFromStr('10,9D'), ['10.9']);
      expect(getAllPricesFromStr('42.0'), ['42.0']);
      expect(getAllPricesFromStr('1999.00'), ['1999.00']);
      expect(getAllPricesFromStr('146.7D'), ['146.7']);
      expect(getAllPricesFromStr('1.000*79.99 79.99A'),
          ['1.000', '79.99', '79.99']);
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
      expect(getAllPricesFromStr('84.9 1.00 x'), ['84.9', '1.00']);
      expect(getAllPricesFromStr('product 1x 42,6D'), ['42.6']);
      expect(getAllPricesFromStr('product 1 x 78.9'), ['78.9']);
      expect(getAllPricesFromStr('product 1x78.9'), ['78.9']);
      expect(getAllPricesFromStr('product1x78.9D'), ['78.9']);
      expect(getAllPricesFromStr('p 78.9'), ['78.9']);
      expect(getAllPricesFromStr('product 42,6D'), ['42.6']);
      expect(getAllPricesFromStr('prod78.9'), ['78.9']);
      expect(getAllPricesFromStr('p78.9AC'), ['78.9']);
      expect(getAllPricesFromStr('42,6D'), ['42.6']);
      expect(getAllPricesFromStr('ad 32.9*84.9 100x'), ['32.9', '84.9']);
      expect(getAllPricesFromStr('product1x789'), []);
      expect(
        getAllPricesFromStr('ad 32.9*84.9 1.00x'),
        ['32.9', '84.9', '1.00'],
      );
      expect(
        getAllPricesFromStr(' WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
        ['1.000', '79.99', '79.99'],
      );
      expect(
        getAllPricesFromStr('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
        ['1.000', '79.99', '79.99'],
      );
      expect(
        getAllPricesFromStr('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A'),
        ['1.000', '79.99', '79.99'],
      );
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

    test('isProductWithPrice', () {
      expect(
          getProductTextWithoutPrice(
              ' WKl 79.99A '),
          'WKl');
      expect(
          getProductTextWithoutPrice(
              ' WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
          'WKŁADY DO SZCZOTECZEK');
      expect(
          getProductTextWithoutPrice(
              'WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A '),
          'WKŁADY DO SZCZOTECZEK');
      expect(
        getProductTextWithoutPrice('WKŁADY DO SZCZOTECZEK 1.000*79.99 79.99A'),
        'WKŁADY DO SZCZOTECZEK',
      );
      expect(getProductTextWithoutPrice('product 1x 42,6D'), 'product');
      expect(getProductTextWithoutPrice('product 1 x 78.9'), 'product');
      expect(getProductTextWithoutPrice('product 1x78.9'), 'product');
      expect(getProductTextWithoutPrice('product1x78.9D'), 'product');
      expect(getProductTextWithoutPrice('extreme product1x78.9D'), 'extreme product');
      expect(getProductTextWithoutPrice('p 78.9'), 'p');
      expect(getProductTextWithoutPrice('product 42,6D'), 'product');
      expect(getProductTextWithoutPrice('prod78.9'), 'prod');
      expect(getProductTextWithoutPrice('p78.9AC'), 'p');
      expect(getProductTextWithoutPrice('42,6D'), '');
      expect(getProductTextWithoutPrice('product1x789'), 'product');
    });
  });
}
