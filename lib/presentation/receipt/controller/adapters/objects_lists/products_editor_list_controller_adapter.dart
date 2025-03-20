import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/controller/adapters/objects_lists/objects_editor_list_controller_adapter.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/objects_lists/products_editor_list_controller.dart';

class ProductsEditorListControllerAdapter
    extends ObjectsEditorListControllerAdapter
    implements ProductsEditorListController {

  ProductsEditorListControllerAdapter({required super.controller});

  @override
  List<ReceiptObjectModel> get objects => controller.modelController.products;

  @override
  AllValuesModel get allValuesData => controller.modelController.allValuesModel;

  @override
  void changeToInfo(int index) => controller.changeProductToInfo(index);

  @override
  void changeToValue(int index) => controller.changeProductToValue(index);

  @override
  bool isSelected(int index) =>
      controller.modelController.isProductSelected(index);

  @override
  ScrollController get scrollController => controller.productsScrollController;

  @override
  ReceiptObjectModelType typeOf(int index) =>
      controller.modelController.products[index].type;

  @override
  bool isInEditMode(int index) =>
      controller.modelController.isProductInEditMode(index);
}
