import 'package:flutter/material.dart';
import 'package:save_receipt/data/models/database_entities.dart';
import 'package:save_receipt/presentation/home/content/products/product_entity.dart';

class ProductsList extends StatelessWidget {
  final List<ProductData> productsData;
  final Function(int) onItemSelected;

  const ProductsList({
    super.key,
    required this.onItemSelected,
    required this.productsData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productsData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: ProductEntity(
            data: productsData[index],
            onPressed: () {
              onItemSelected(index);
            },
          ),
        );
      },
    );
  }
}
