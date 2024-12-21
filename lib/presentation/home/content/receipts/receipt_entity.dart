import 'dart:io';

import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/models/document.dart';

class ReceiptEntity extends StatelessWidget {
  final ReceiptDocumentData data;
  final VoidCallback onPressed;
  final Color? color;
  const ReceiptEntity(
      {super.key, required this.data, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    String title = "Receipt from ${data.receipt.date}";
    String product1 = "";
    String product2 = "";
    ImageProvider img = data.receipt.imgPath != null
        ? FileImage(File(data.receipt.imgPath!))
        : const AssetImage('assets/no_image.jpg');
    if (data.products.isNotEmpty) {
      product1 = data.products[0].name;
    }
    if (data.products.length >= 2) {
      product2 = data.products[1].name;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: mainTheme.mainColor.withOpacity(0.2), // Shadow color
              spreadRadius: 5, // How much the shadow spreads
              blurRadius: 5, // How blurry the shadow is
              offset: const Offset(
                  0, 3), // Changes position of shadow (horizontal, vertical)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, bottom: 8.0, right: 9.0, top: 8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: mainTheme.extraLightMainColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: img,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                height: 54.0,
                width: 54.0,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainTheme.mainColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product1,
                      style: TextStyle(color: mainTheme.mainColor),
                    ),
                    Text(
                      product2,
                      style: TextStyle(color: mainTheme.mainColor),
                    ),
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
