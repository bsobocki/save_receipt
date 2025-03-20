import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/shared/enums.dart';

abstract class ObjectsEditorListController {
  AllValuesModel get allValuesData;
  List<ReceiptObjectModel> get objects;
  ScrollController get scrollController;
  DataFieldMode dataFieldModeOf(int index);
  ReceiptObjectModelType typeOf(int index);
  bool isInEditMode(int index);
  bool isSelected(int index);

  void remove(int index);
  void setEditModeOf(int index);
  void toggleSelectionOf(int index);
  void changeToValue(int index);

  void toggleSelectionMode();
  void trackChange();
}
