import 'dart:io';

import 'package:flutter/material.dart';
import 'package:save_receipt/data/models/document.dart';

class ReceiptEntity extends StatelessWidget {
  final ReceiptDocumentData data;
  final VoidCallback onPressed;
  final Color color;
  const ReceiptEntity(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    String title = "Receipt from ${data.receipt.date}";
    String product1 = "";
    String product2 = "";
    Image img = data.receipt.imgPath != null
        ? Image.file(File(data.receipt.imgPath!))
        : Image.asset('assets/no_image.jpg');
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                color: Colors.white.withOpacity(0.4),
                height: 100.0,
                width: 100.0,
                child: img,
              ),
              const SizedBox(width: 26.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(product1),
                    Text(product2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
