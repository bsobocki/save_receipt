import 'package:flutter/material.dart';
import 'package:save_receipt/data/models/document.dart';

class ReceiptEntity extends StatelessWidget {
  final ReceiptDocumentData data;
  final VoidCallback onPressed;
  final Color color;
  const ReceiptEntity({super.key, required this.data, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    String title = "Receipt from ${data.receipt.date}";
    String product1 = "Dummy product";
    String product2 = "Dummy product";
    if (data.products.isNotEmpty) {
      product1 = data.products[0].name;
    }
    if (data.products.length >= 2) {
      product2 = data.products[1].name;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: color,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('   $product1'),
            Text('   $product2'),
          ],
        ),
      ),
    );
  }
}
