const String priceRegex = r'[0-9]+[,\.][0-9]+';
const String amountRegex = r'([ \t][0-9\.,x*]+)|([0-9\.,x*]+[ \t])|([0-9][x*,\.][0-9]*)|([0-9]*[x*,\.][0-9])';
const String additionalPriceMarksRegex = r'[a-zA-Z]{0,2}';

bool isNumeric(String data) {
  return false;
}

bool isProductWithPrice(String data) {
  RegExp regex =
      RegExp(r'[a-zA-Z]+[ \t]*' + priceRegex + additionalPriceMarksRegex);
  return regex.hasMatch(data) && isPrice(getAllPricesFromStr(data).last);
}

bool isPrice(String data) {
  RegExp regex = RegExp(r'^' + priceRegex + additionalPriceMarksRegex + r'$');
  return regex.hasMatch(data) && double.tryParse(getPriceStr(data)) != null;
}

bool hasPrice(String data) {
  RegExp regex = RegExp(priceRegex);
  return regex.hasMatch(data) && double.tryParse(getPriceStr(data)) != null;
}

String getPriceStr(String data) {
  RegExp regex = RegExp(priceRegex);
  List<RegExpMatch> matches = regex.allMatches(data).toList();
  return matches.isEmpty ? '' : matches.last[0]?.replaceAll(RegExp(','), '.') ?? '';
}

String getProductTextWithoutPrice(String data) {
  return data
      .replaceAll(RegExp('$priceRegex$additionalPriceMarksRegex'), '')
      .replaceAll(RegExp(amountRegex), '')
      .trim();
}

List<String> getAllPricesFromStr(String data) {
  RegExp regex = RegExp(priceRegex);
  return regex
      .allMatches(data)
      .map((e) => e[0]?.replaceAll(RegExp(','), '.') ?? '')
      .toList();
}

bool isDate(String data) {
  RegExp regex =
      RegExp(r'([0-9]+:[0-9]+)+|[ \t]*([0-9]+[\-\\/][0-9]+[\-\\/][0-9]+).*');
  return regex.hasMatch(data);
}

double parsePrice(String data) {
  return 0.0;
}
