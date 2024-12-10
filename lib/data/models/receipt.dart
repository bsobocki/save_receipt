class ReceiptData {
  final int? id; // null for new receipts - database will create a new id
  final int? shopId;
  final String date;
  final double totalCost;
  final String? imgPath;

  ReceiptData({
    this.id,
    this.shopId,
    required this.totalCost,
    required this.imgPath,
    required this.date,
  });

  ReceiptData copyWith({
    final int? id,
    final int? shopId,
    final String? date,
    final double? totalCost,
    final String? imgPath,
  }) {
    return ReceiptData(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      date: date ?? this.date,
      totalCost: totalCost ?? this.totalCost,
      imgPath: imgPath ?? this.imgPath,
    );
  }

  @override
  String toString() =>
      'Receipt(id: $id, shop_id: $shopId, date: $date, total_amount: $totalCost, img_path: $imgPath)';
}
