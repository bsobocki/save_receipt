import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/gradients/main_gradients.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/models/document.dart';

class ReceiptEntity extends StatelessWidget {
  final ReceiptDocumentData data;
  final VoidCallback onPressed;
  final VoidCallback onRemoved;
  final ThemeController themeController = Get.find();

  ReceiptEntity({
    super.key,
    required this.data,
    required this.onPressed,
    required this.onRemoved,
  });

  Widget get imageContainer {
    ImageProvider img = data.receipt.imgPath != null
        ? FileImage(File(data.receipt.imgPath!))
        : const AssetImage('assets/no_image.jpg');
    Color borderColor =
        themeController.theme.extraLightMainColor.withOpacity(0.3);
    return Container(
      height: 54.0,
      width: 54.0,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: img,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget getFieldSwipeBackground(final IconData iconData,
          final LinearGradient gradient, Alignment alignment) =>
      Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Icon(iconData),
        ),
      );

  @override
  Widget build(BuildContext context) {
    String title = "Receipt from ${data.receipt.time}";
    String product1 = "";
    String product2 = "";
    if (data.products.isNotEmpty) {
      product1 = data.products[0].name;
    }
    if (data.products.length >= 2) {
      product2 = data.products[1].name;
    }
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => onRemoved(),
      background: getFieldSwipeBackground(
        Icons.close,
        redToTransparentGradient,
        Alignment.centerLeft,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: themeController.theme.mainColor
                    .withOpacity(0.2), // Shadow color
                spreadRadius: 5, // How much the shadow spreads
                blurRadius: 5, // How blurry the shadow is
                offset: const Offset(
                    0, 3), // Changes position of shadow (horizontal, vertical)
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 8.0,
              right: 9.0,
              top: 8.0,
            ),
            child: Row(
              children: [
                imageContainer,
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeController.theme.mainColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product1,
                        style:
                            TextStyle(color: Colors.grey[700]!, fontSize: 12),
                      ),
                      Text(
                        product2,
                        style:
                            TextStyle(color: Colors.grey[700]!, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
