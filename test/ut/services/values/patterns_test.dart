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
      expect(
        getPriceStr('1.000*79.99 79.99A'),
        '79.99',
      );
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

    test('getProductTextWithoutPrice', () {
      expect(getProductTextWithoutPrice(' WKl 79.99A '), 'WKl');
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
      expect(getProductTextWithoutPrice('extreme product1x78.9D'),
          'extreme product');
      expect(getProductTextWithoutPrice('p 78.9'), 'p');
      expect(getProductTextWithoutPrice('product 42,6D'), 'product');
      expect(getProductTextWithoutPrice('prod78.9'), 'prod');
      expect(getProductTextWithoutPrice('p78.9AC'), 'p');
      expect(getProductTextWithoutPrice('42,6D'), '');
      expect(getProductTextWithoutPrice('product1x789'), 'product');
    });

    test('isTime', () {
      expect(isTime('NIP: 754-3994-213-414'), false);
      expect(isTime('2011-05-18'), true);
      expect(isTime('2011/05/18'), true);
      expect(isTime(' Śr 2011_05_18'), true);
      expect(isTime('Czw 2011 05 18'), true);
      expect(isTime('2011:05:18 Mon'), true);
      expect(isTime('Wed 2011-05-18'), true);
      expect(isTime('Wed 20:11'), true);
      expect(isTime('2011-05-18 .'), true);

      // generated tests:

      // Leading space is allowed:
      expect(isTime(' 2011-05-18'), true);
      // Trailing space is allowed:
      expect(isTime('2011-05-18 '), true);
      // Surrounded by text with whitespace before and after:
      expect(isTime('some text 2011-12-31 some text'), true);
      // Single-digit month/day:
      expect(isTime('2011-5-1'), true);
      // Mixed separators:
      expect(isTime('2011_5_1'), true); // underscores
      expect(isTime('2011/5/1'), true); // forward slash
      expect(isTime(r'2011\5\1'), true); // backslash
      // Hours or times:
      expect(isTime('14:00'), true);
      expect(isTime('14:30:10'), true);
      // 2-digit year:
      expect(isTime('21-05-18'), true);
      // Reverse date format (day-month-year):
      expect(isTime('05/18/2011'), true);
      // Another day-month-year style with underscores:
      expect(isTime('5_18_11'), true);

      // No whitespace before the date => fails:
      expect(isTime('some text2011-05-18'), false);
      // No whitespace after the date => fails:
      expect(isTime('2011-05-18,some text'), false);
      // Extra punctuation right after the date => fails (comma not allowed before whitespace/end):
      expect(isTime('2011-05-18,'), false);
      // Too many digits throws off matching (5-digit year):
      expect(isTime('99999-12-31'), false);
      // Missing separator:
      expect(isTime('20110518'), false);
      // Punctuation mismatch, e.g. dash + colon + underscore in a weird place:
      expect(isTime('2011:-_05-18'), false);
      // No actual date or time in numeric form:
      expect(isTime('today is Wed'), false);

      // simple date range-checking (without going deeper - 30 feb or 31 April are alowed)

      // Typical ISO-like date
      expect(isTime('2011-05-18'), true); // year=2011, month=05, day=18
      expect(isTime('99-12-31'), true); // year=99, month=12, day=31
      expect(isTime('0001-1-1'),
          true); // unusual but valid by pattern (year=0001, mo=1, day=1)

      // Different separators
      expect(isTime('2011/05/18'), true);
      expect(isTime(r'2011\05\18'), true);
      expect(isTime('2011:05:18'), true);
      expect(isTime('2011_05_18'), true);
      expect(isTime('2011.05.18'), true);

      // Day-month-year style
      expect(isTime('18-05-2011'), true);
      // Month-day-year style
      expect(isTime('05-18-2011'), true);

      // Leading zeros for day/month
      expect(isTime('2011-01-09'), true); // January 9
      expect(isTime('03-07-21'), true); // day=07, year=21, mo=3

      // Times within valid range
      expect(isTime('00:00'), true); // hour=0 , minute=0, no seconds
      expect(isTime('23:59'), true); // hour=23 , minute=59, no seconds
      expect(isTime('23:59:59'), true); // hour=23 , minute=59, seconds=59
      expect(isTime('07:05'), true); // hour=7 , minute=05
      expect(isTime('07:05:09'), true); // hour=7 , minute=05, second=09
      expect(isTime('19:59:0'),
          true); // hour=19 , minute=59, second=0 (leading zeros optional)

      // Out-of-range months or days
      expect(isTime('2011-13-18'), false); // month=13 not allowed
      expect(isTime('2011-05-32'), false); // day=32 not allowed
      expect(isTime('2011-00-15'), false); // month=0 not allowed
      expect(isTime('2011-05-0'), false); // day=0 not allowed

      // better range-checking for time

      // Times out of range
      expect(isTime('24:00'), false); // hour=24 not allowed
      expect(isTime('23:60'), false); // minute=60 not allowed
      expect(isTime('23:59:60'), false); // second=60 not allowed
      expect(isTime('09:999'), false); // minutes=999 definitely out of range
      expect(isTime('25:10'), false); // hour=25 not allowed
      expect(isTime('07:65'), false); // minute=65 not allowed

      // Formatting issues
      expect(isTime('2011-05-18,'),
          false); // comma after date won't match (?:\s|$)
      expect(isTime('some2011-05-18'),
          false); // no whitespace or start-of-string before 2011
      expect(isTime('2011-05-188'), false); // leftover digit "8" after day=18
      expect(isTime('2011- 05-18'),
          false); // dash followed by space in the month => breaks monthRegex = 0*[1-9] or 1[0-2]

      // The pattern doesn't do real calendar checks, so 02/30 or 04/31 would match
      // in pure format terms. If you want to see that the pattern doesn't catch it:
      expect(isTime('2011-02-30'),
          true); // matches format, despite being an invalid date
      expect(isTime('04-31-2023'),
          true); // also matches format, but April 31 doesn't exist

      expect(isTime('2011-05-18 13:15'), true);
      expect(isTime('2011-05-18 13:15:05'), true);
      expect(isTime('99/01/09 00:00'), true);
      expect(isTime('05_18_21 23:59:59'), true);
    });
  });
}
