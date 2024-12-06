class ReceiptData {
  final int id;
  final int shopId;
  final String date;
  final int totalAmount;
  final String imgPath;

  ReceiptData({ required this.shopId, required this.totalAmount, required this.imgPath,
      required this.id, required this.date,});
   
  ReceiptData copyWith({
    final int? id,
    final int? shopId,
    final String? date,
    final int? totalAmount,
    final String? imgPath,
  }) {
    return ReceiptData(
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