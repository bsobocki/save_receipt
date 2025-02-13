const String priceRegex = r'[0-9]+[,\.][0-9]+';
const String amountRegex =
    r'([ \t][0-9\.,x*]+)|([0-9\.,x*]+[ \t])|([0-9][x*,\.][0-9]*)|([0-9]*[x*,\.][0-9])';
const String additionalPriceMarksRegex = r'[a-zA-Z]{0,2}';

// start with space or just start string
// ?: means that we don't want to capture this group
const String startRegex = r'(?:^|\s)';
const String endRegex = r'(?:\s|$)';

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
  return matches.isEmpty
      ? ''
      : matches.last[0]?.replaceAll(RegExp(','), '.') ?? '';
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
  const String hourRegex = r'[0-9]+:[0-9]+[:]*[0-9]*';
  const String yearRegex = r'(?:[0-9]{4}|[0-9]{2})';
  const String dayMonthRegex = r'[0-9]{1,2}';
  const String dateSepRegex = r'[:\/\\_ -]';
  const String dateStartsWithYearRegex =
      '$yearRegex$dateSepRegex$dayMonthRegex$dateSepRegex$dayMonthRegex';
  const String dateEndsWithYearRegex =
      '$dayMonthRegex$dateSepRegex$dayMonthRegex$dateSepRegex$yearRegex';
  String dateRegex =
      '$startRegex(?:$dateStartsWithYearRegex|$dateEndsWithYearRegex|$hourRegex)$endRegex';

  return RegExp(dateRegex).hasMatch(data);
}

double parsePrice(String data) {
  return 0.0;
}
