import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';

abstract class ProductsListController {
  AllValuesModel get allValuesData;
  List<ReceiptObjectModel> get products;
  ScrollController get scrollController;
  DataFieldMode dataFieldModeOf(int index);
  bool isSelected(int index);

  void remove(int index);
  void setEditModeOf(int index);
  void toggleSelectionOf(int index);
  void changeToValue(int index);
  void changeToInfo(int index);
  void toggleSelectionMode();
  void trackChange();
}
