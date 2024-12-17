import 'package:flutter/material.dart';
import 'package:save_receipt/data/models/database_entities.dart';

class ProductEntity extends StatelessWidget {
  final ProductData data;
  final VoidCallback onPressed;
  final Color color;
  const ProductEntity({
    super.key,
    required this.data,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // product images are not supported yet
    // Image img = data.receipt.imgPath != null
    //     ? Image.file(File(data.receipt.imgPath!))
    //     : Image.asset('assets/no_image.jpg');

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(data.price.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
