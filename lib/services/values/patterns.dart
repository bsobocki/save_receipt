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
  const String secondsRegex = r'(?:[0-5]*[0-9])';
  const String minutesRegex = r'(?:[0-5]*[0-9])';
  const String hourRegex = r'(?:[01]*[0-9]|2[0-3])';
  const String endingRegex = '(?::$secondsRegex|(?::$secondsRegex:[0-9]+))';
  const String timeRegex = '$hourRegex:$minutesRegex$endingRegex*';

  const String yearRegex = r'(?:[0-9]{4}|[0-9]{2})';
  const String dayRegex = r'(?:0*[1-9]|[12]\d|3[01])';
  const String monthRegex = r'(?:0*[1-9]|1[0-2])';
  const String dateSepRegex = r'[:.\/\\_ -]';

  const String yearMonthDayRegex =
      '$yearRegex$dateSepRegex$monthRegex$dateSepRegex$dayRegex';
  const String yearDayMonthRegex =
      '$yearRegex$dateSepRegex$dayRegex$dateSepRegex$monthRegex';
  const String dayMonthYearRegex =
      '$dayRegex$dateSepRegex$monthRegex$dateSepRegex$yearRegex';
  const String monthDayYearRegex =
      '$monthRegex$dateSepRegex$dayRegex$dateSepRegex$yearRegex';

  String dateRegex = '$startRegex'
      '(?:$yearMonthDayRegex|'
      '$yearDayMonthRegex|'
      '$dayMonthYearRegex|'
      '$monthDayYearRegex|'
      '$timeRegex)'
      '$endRegex';

  return RegExp(dateRegex).hasMatch(data);
}

double parsePrice(String data) {
  return 0.0;
}
