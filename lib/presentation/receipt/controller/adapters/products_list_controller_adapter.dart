import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/products_editor_lists_controller_interface.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';

class ProductsEditorListControllerAdapter
    implements ProductsEditorListController {
  final ReceiptEditorPageController controller;

  ProductsEditorListControllerAdapter({required this.controller});

  @override
  List<ReceiptObjectModel> get products => controller.modelController.products;

  @override
  AllValuesModel get allValuesData => controller.modelController.allValuesModel;

  @override
  DataFieldMode dataFieldModeOf(int index) =>
      controller.modelController.isSelectionModeEnabled.value
          ? DataFieldMode.select
          : controller.modelController.isProductInEditMode(index)
              ? DataFieldMode.edit
              : DataFieldMode.normal;

  @override
  void changeToInfo(int index) => controller.changeProductToInfo(index);

  @override
  void changeToValue(int index) => controller.changeProductToValue(index);

  @override
  bool isSelected(int index) =>
      controller.modelController.isProductSelected(index);

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
}
