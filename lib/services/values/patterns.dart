const String priceRegex = r'[0-9]+[,\.][0-9]+';

bool isNumeric(String data) {
  return false;
}

bool isProductWithPrice(String data) {
  RegExp regex = RegExp(r'[a-zA-Z]+[ \t]*' + priceRegex + r'[a-zA-Z]*');
  return regex.hasMatch(data) && isPrice(getAllPricesFromStr(data).last);
}

bool isPrice(String data) {
  RegExp regex = RegExp(r'^' + priceRegex + r'[a-zA-Z]{0,2}$');
  return regex.hasMatch(data) && double.tryParse(getPriceStr(data)) != null;
}

bool hasPrice(String data) {
  RegExp regex = RegExp(priceRegex);
  return regex.hasMatch(data) && double.tryParse(getPriceStr(data)) != null;
}

String getPriceStr(String data) {
  RegExp regex = RegExp(priceRegex);
  return regex.firstMatch(data)?[0]?.replaceAll(RegExp(','), '.') ?? '';
}

String getProductTextWithoutPrice(String data) {
  List<String> dataWithoutPrices =
      data.split(' ').where((e) => !isPrice(e)).toList();

  return dataWithoutPrices.isEmpty
      ? ''
      : dataWithoutPrices.reduce((value, element) => '$value $element');
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
