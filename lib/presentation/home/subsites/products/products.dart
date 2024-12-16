import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/models/database_entities.dart';
import 'package:save_receipt/presentation/home/subsites/products/product_entity.dart';

class ProductsList extends StatefulWidget {
  final List<ProductData> productsData;
  final Function(int) onItemSelected;

  const ProductsList({
    super.key,
    required this.onItemSelected,
    required this.productsData,
  });

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.productsData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductEntity(
            color: mainTheme.mainColor,
            data: widget.productsData[index],
            onPressed: () {
              widget.onItemSelected(index);
            },
          ),
        );
      },
    );
  }
}
