class ReceiptData {
  final int? id; // null for new receipts - database will create a new id
  final int? shopId;
  final String time;
  final double totalCost;
  final String? imgPath;

  ReceiptData({
    this.id,
    this.shopId,
    required this.totalCost,
    required this.imgPath,
    required this.time,
  });

  ReceiptData copyWith({
    final int? id,
    final int? shopId,
    final String? time,
    final double? totalCost,
    final String? imgPath,
  }) {
    return ReceiptData(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      time: time ?? this.time,
      totalCost: totalCost ?? this.totalCost,
      imgPath: imgPath ?? this.imgPath,
    );
  }

  @override
  String toString() =>
      'Receipt(id: $id, shop_id: $shopId, time: $time, total_amount: $totalCost, img_path: $imgPath)';
}
