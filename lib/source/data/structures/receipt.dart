class ReceiptModel {
  final String? imgPath;
  final List<ReceiptModelObject> objects;

  const ReceiptModel({this.imgPath, required this.objects});

  List<ReceiptModelObject> getObjects(ReceiptModelObjectType type) {
    List<ReceiptModelObject> objs = [];
    for (ReceiptModelObject obj in objects) {
      if (obj.type == type) {
        objs.add(obj);
      }
    }
    return objs;
  }

  getObjectsAsStr(ReceiptModelObjectType type) {
    List<String> objs = [];
    for (ReceiptModelObject obj in objects) {
      if (obj.type == type) {
        objs.add(obj.valueStr);
      }
    }
    return objs;
  }

  List<ReceiptModelProduct> get products =>
      getObjects(ReceiptModelObjectType.product)
          .map((e) => e as ReceiptModelProduct)
          .toList();

  get prices => products.map((e) => e.price).toList();
  get info => getObjects(ReceiptModelObjectType.info);
  get dates => getObjects(ReceiptModelObjectType.date);
  get pricesStr => getObjectsAsStr(ReceiptModelObjectType.product);
  get infoStr => getObjectsAsStr(ReceiptModelObjectType.info);
  get datesStr => getObjectsAsStr(ReceiptModelObjectType.date);

  @override
  String toString() => 'img: $imgPath, [$objects]';
}

enum ReceiptModelObjectType { object, product, info, date }

class ReceiptModelObject {
  final String text;

  const ReceiptModelObject({required this.text});

  get type => ReceiptModelObjectType.object;
  get valueStr => '';

  @override
  String toString() => '\n text: $text';
}

class ReceiptModelProduct extends ReceiptModelObject {
  final double price;

  const ReceiptModelProduct({required super.text, required this.price});

  @override
  get type => ReceiptModelObjectType.product;
  @override
  get valueStr => price.toString();

  @override
  String toString() {
    return '${super.toString()}| price: $price';
  }
}

class ReceiptModelInfo extends ReceiptModelObject {
  final String info;

  const ReceiptModelInfo({required super.text, required this.info});

  @override
  get type => ReceiptModelObjectType.info;
  @override
  get valueStr => info;

  @override
  String toString() {
    return '${super.toString()}| info: $info';
  }
}

class ReceiptModelDate extends ReceiptModelObject {
  final String date;

  const ReceiptModelDate({required super.text, required this.date});

  @override
  get type => ReceiptModelObjectType.date;
  @override
  get valueStr => date;

  @override
  String toString() {
    return '${super.toString()}| date: $date';
  }
}
