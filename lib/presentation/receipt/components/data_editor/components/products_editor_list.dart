import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/products_editor_list_controller.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/presentation/receipt/data_field/product_data_field.dart';

class ProductsEditorList extends StatelessWidget {
  final ProductsEditorListController controller;
  const ProductsEditorList({
    required super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiptEditorPageController>(
      builder: (_) => ListView.builder(
        key: key,
        itemCount: controller.objects.length,
        controller: controller.scrollController,
        itemBuilder: (context, index) {
          return ProductDataField(
            key: UniqueKey(),
            onChangedData: controller.trackChange,
            model: controller.objects[index],
            allValuesData: controller.allValuesData,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => controller.remove(index),
            onItemEditModeSwipe: () => controller.setEditModeOf(index),
            onChangedToValue: () => controller.changeToValue(index),
            onChangedToInfo: () => controller.changeToInfo(index),
            mode: controller.dataFieldModeOf(index),
            selected: controller.isSelected(index),
            onSelected: () => controller.toggleSelectionOf(index),
            onLongPress: controller.toggleSelectionMode,
          );
        },
      ),
    );
  }
}
