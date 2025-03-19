import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/info_editor_list_controller.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/presentation/receipt/data_field/info_data_field.dart';

class InfoEditorList extends StatelessWidget {
  final InfoEditorListController controller;
  const InfoEditorList({
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
          VoidCallback? onChangedToProduct;
          if (controller.isInfoDouble(index)) {
            onChangedToProduct =
                () => controller.changeToProduct(index);
          }
          return InfoDataField(
            key: UniqueKey(),
            onChangedData: controller.trackChange,
            model: controller.objects[index],
            allValuesData: controller.allValuesData,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => controller.remove(index),
            onItemEditModeSwipe: () => controller.setEditModeOf(index),
            onChangedToValue: () => controller.changeToValue(index),
            onValueToFieldChanged: () => controller.createFromValueOf(index),
            onValueTypeChanged: (ReceiptObjectModelType type) =>
                controller.changeValueType(index, type),
            onChangedToProduct: onChangedToProduct,
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
