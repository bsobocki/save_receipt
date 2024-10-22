class Receipt {
  final String? imgPath;
  final List<ReceiptObject> objects;

  const Receipt({this.imgPath, required this.objects});

  getObjects(ReceiptObjectType type) {
    List<Product> objs = [];
    for (ReceiptObject obj in objects) {
      if (obj.type == type) {
        objs.add(obj as Product);
      }
    }
    return objs;
  }

  get products => getObjects(ReceiptObjectType.product);
  get info => getObjects(ReceiptObjectType.info);
  get dates => getObjects(ReceiptObjectType.date);

  @override
  String toString() => 'img: $imgPath, [$objects]';
}

enum ReceiptObjectType { object, product, info, date }

class ReceiptObject {
  final String text;

  const ReceiptObject({required this.text});

  get type => ReceiptObjectType.object;

  @override
  String toString() => '\n text: $text';
}

class Product extends ReceiptObject {
  final double price;

  const Product({required super.text, required this.price});

  @override
  get type => ReceiptObjectType.product;

  @override
  String toString() {
    return '${super.toString()}| price: $price';
  }
}

class TwoPartInfo extends ReceiptObject {
  final String info;

  const TwoPartInfo({required super.text, required this.info});

  @override
  get type => ReceiptObjectType.info;

  @override
  String toString() {
    return '${super.toString()}| info: $info';
  }
}

class Date extends ReceiptObject {
  final String date;

  const Date({required super.text, required this.date});

  @override
  get type => ReceiptObjectType.date;

  @override
  String toString() {
    return '${super.toString()}| date: $date';
  }
}
