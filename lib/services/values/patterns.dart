bool isNumeric(String data) {
  return false;
}

bool isProductWithPrice(String data) {
  RegExp regex = RegExp(r'[a-zA-Z]+[ \t]*[0-9]+[,\.][0-9]+[a-zA-Z]*');
  print(regex.allMatches(data).map((e) => e.input,).toList());
  return regex.hasMatch(data); // && isPrice(regex.allMatches(data).last.input);
}

bool isPrice(String data) {
  RegExp regex = RegExp(r'^[0-9]*[x ]*[0-9]+[,\.][0-9]+[a-zA-Z]{0,2}$');
  return regex.hasMatch(data) && double.tryParse(getPriceStr(data)) != null;
}

String getPriceStr(String data) {
  RegExp regex = RegExp(r'([0-9]+[,\.]*[0-9]+)');
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
  RegExp regex = RegExp(r'([0-9]+[,\.]*[0-9]+)');
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
