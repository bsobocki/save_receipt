class Receipt {
  final String? imgPath;
  final List<ReceiptObject> objects;

  const Receipt({this.imgPath, required this.objects});

  getObjects(ReceiptObjectType type) {
    List<ReceiptObject> objs = [];
    for (ReceiptObject obj in objects) {
      if (obj.type == type) {
        objs.add(obj);
      }
    }
    return objs;
  }

  getObjectsAsStr(ReceiptObjectType type) {
    List<String> objs = [];
    for (ReceiptObject obj in objects) {
      if (obj.type == type) {
        objs.add(obj.valueStr);
      }
    }
    return objs;
  }

  get products => getObjects(ReceiptObjectType.product);
  get info => getObjects(ReceiptObjectType.info);
  get dates => getObjects(ReceiptObjectType.date);
  get pricesStr => getObjectsAsStr(ReceiptObjectType.product);
  get infoStr => getObjectsAsStr(ReceiptObjectType.info);
  get datesStr => getObjectsAsStr(ReceiptObjectType.date);

  @override
  String toString() => 'img: $imgPath, [$objects]';
}

enum ReceiptObjectType { object, product, info, date }

class ReceiptObject {
  final String text;

  const ReceiptObject({required this.text});

  get type => ReceiptObjectType.object;
  get valueStr => '';

  @override
  String toString() => '\n text: $text';
}

class ReceiptProduct extends ReceiptObject {
  final double price;

  const ReceiptProduct({required super.text, required this.price});

  @override
  get type => ReceiptObjectType.product;
  @override
  get valueStr => price.toString();

  @override
  String toString() {
    return '${super.toString()}| price: $price';
  }
}

class ReceiptInfo extends ReceiptObject {
  final String info;

  const ReceiptInfo({required super.text, required this.info});

  @override
  get type => ReceiptObjectType.info;
  @override
  get valueStr => info;

  @override
  String toString() {
    return '${super.toString()}| info: $info';
  }
}

class ReceiptDate extends ReceiptObject {
  final String date;

  const ReceiptDate({required super.text, required this.date});

  @override
  get type => ReceiptObjectType.date;
  @override
  get valueStr => date;

  @override
  String toString() {
    return '${super.toString()}| date: $date';
  }
}
