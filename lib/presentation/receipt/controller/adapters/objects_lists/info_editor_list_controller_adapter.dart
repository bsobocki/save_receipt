import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/controller/adapters/objects_lists/objects_editor_list_controller_adapter.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/objects_lists/info_editor_list_controller.dart';

class InfoEditorListControllerAdapter extends ObjectsEditorListControllerAdapter
    implements InfoEditorListController {
  InfoEditorListControllerAdapter({required super.controller});

  @override
  List<ReceiptObjectModel> get objects => controller.modelController.infos;

  @override
  void changeToProduct(int index) =>
      controller.changeInfoDoubleToProduct(index);

  @override
  void changeToValue(int index) => controller.changeInfoToValue(index);

  @override
  bool isSelected(int index) =>
      controller.modelController.isInfoSelected(index);

  @override
  ScrollController get scrollController => controller.infoScrollController;

  @override
  ReceiptObjectModelType typeOf(int index) =>
      controller.modelController.infos[index].type;

  @override
  bool isInEditMode(int index) =>
      controller.modelController.isInfoInEditMode(index);

  @override
  void changeValueType(int index, ReceiptObjectModelType newType) =>
      controller.modelController.changeInfoValueType(newType, index);

  @override
  bool isInfoDouble(int index) =>
      typeOf(index) == ReceiptObjectModelType.infoDouble;

  @override
  void createFromValueOf(int index) => controller.changeValueToInfo(index);
}
