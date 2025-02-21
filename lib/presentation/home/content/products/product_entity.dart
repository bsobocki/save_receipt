import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/models/database_entities.dart';

class ProductEntity extends StatelessWidget {
  final ProductData data;
  final VoidCallback onPressed;
  const ProductEntity({
    super.key,
    required this.data,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // product images are not supported yet
    // Image img = data.receipt.imgPath != null
    //     ? Image.file(File(data.receipt.imgPath!))
    //     : Image.asset('assets/no_image.jpg');
    final ThemeController themeController = Get.find();
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0.0),
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
              top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeController.theme.mainColor),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data.price.toString(),
                style: TextStyle(color: Colors.grey[700]!, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
