class Receipt {
  final int id;
  final int shopId;
  final String date;
  final int totalAmount;
  final String imgPath;

  Receipt({ required this.shopId, required this.totalAmount, required this.imgPath,
      required this.id, required this.date,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_id': shopId,
      'date': date,
      'total_amount': totalAmount,
      'img_path': imgPath,
    };
  }

  Receipt.fromMap(Map<String, dynamic> map):
    id = map['id'],
    shopId = map['shop_id'],
    date = map['date'],
    totalAmount = map['total_amount'],
    imgPath = map['img_path'];

  Receipt copyWith({
    final int? id,
    final int? shopId,
    final String? date,
    final int? totalAmount,
    final String? imgPath,
  }) {
    return Receipt(
      id: id ?? this.id,
      shopId : shopId ?? this.shopId,
    date : date ?? this.date,
    totalAmount : totalAmount ?? this.totalAmount,
    imgPath : imgPath ?? this.imgPath,
    );
  }

  @override
  String toString() => 
    'Receipt(id: $id, shop_id: $shopId, date: $date, total_amount: $totalAmount, img_path: $imgPath)';
}