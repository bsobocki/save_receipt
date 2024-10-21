class Receipt {
  final String imgPath;
  final List<ReceiptObject> objects;

  const Receipt({required this.imgPath, required this.objects});

  get products {
    List<Product> prods = [];
    for (ReceiptObject obj in objects) {
      if (obj.isProduct) {
        prods.add(obj as Product);
      }
    }
    return prods;
  }

  @override
  String toString() => 'img: $imgPath, [$objects]';
}

class ReceiptObject {
  final String text;

  const ReceiptObject({required this.text});

  get isProduct => false;
  @override
  String toString() => '\n text: $text';
}

class Product extends ReceiptObject {
  final double price;

  const Product({required super.text, required this.price});

  @override
  get isProduct => true;

  @override
  String toString() {
    return '${super.toString()}| price: $price';
  }
}

class TwoPartInfo extends ReceiptObject {
  final String info;

  const TwoPartInfo({required super.text, required this.info});

  @override
  get isProduct => true;

  @override
  String toString() {
    return '${super.toString()}| info: $info';
  }
}

class Date extends ReceiptObject {
  final String date;

  const Date({required super.text, required this.date});

  @override
  get isProduct => true;

  @override
  String toString() {
    return '${super.toString()}| date: $date';
  }
}
