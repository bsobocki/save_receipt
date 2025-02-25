class ReceiptData {
  final int? id; // null for new receipts - database will create a new id
  final String title;
  final int? shopId;
  final String time;
  final double totalCost;
  final String? imgPath;

  ReceiptData({
    this.id,
    required this.title,
    this.shopId,
    required this.totalCost,
    required this.imgPath,
    required this.time,
  });

  ReceiptData copyWith({
    final int? id,
    final String? title,
    final int? shopId,
    final String? time,
    final double? totalCost,
    final String? imgPath,
  }) {
    return ReceiptData(
      id: id ?? this.id,
      title: title ?? this.title,
      shopId: shopId ?? this.shopId,
      time: time ?? this.time,
      totalCost: totalCost ?? this.totalCost,
      imgPath: imgPath ?? this.imgPath,
    );
  }

  @override
  String toString() =>
      'Receipt(id: $id, title: $title, shop_id: $shopId, time: $time, total_amount: $totalCost, img_path: $imgPath)';
}
