import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/objects_lists/objects_editor_list_controller.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/presentation/receipt/shared/enums.dart';

abstract class ObjectsEditorListControllerAdapter
    implements ObjectsEditorListController {
  final ReceiptEditorPageController controller;

  ObjectsEditorListControllerAdapter({required this.controller});

  @override
  AllValuesModel get allValuesData => controller.modelController.allValuesModel;

  @override
  DataFieldMode dataFieldModeOf(int index) =>
      controller.modelController.isSelectionModeEnabled.value
          ? DataFieldMode.select
          : isInEditMode(index)
              ? DataFieldMode.edit
              : DataFieldMode.normal;

  @override
  void remove(int index) => controller.removeObjectByIndex(index);

  @override
  void setEditModeOf(int index) => controller.setEditModeForObject(index);

  @override
  void toggleSelectionOf(int index) => controller.toggleObjectSelection(index);

  @override
  void toggleSelectionMode() => controller.toggleSelectionMode();

  @override
  void trackChange() => controller.modelController.trackChange();

  @override
  ScrollController get scrollController => controller.productsScrollController;

  @override
  ReceiptObjectModelType typeOf(int index) =>
      controller.modelController.products[index].type;
}
