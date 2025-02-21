import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/gradients/main_gradients.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

enum DataFieldMode { normal, edit, select }

class DataField extends StatefulWidget {
  final bool isDarker;
  final DataFieldMode mode;
  final Widget editModeContent;
  final Widget normalModeContent;
  final Widget selectModeContent;
  final ReceiptObjectModel model;
  final AllValuesModel allValuesData;
  final Function() onItemDismissSwipe;
  final Function() onItemEditModeSwipe;
  final Function(DismissDirection direction)? onItemSwipe;

  const DataField({
    super.key,
    required this.mode,
    required this.model,
    required this.allValuesData,
    required this.isDarker,
    required this.onItemDismissSwipe,
    required this.onItemEditModeSwipe,
    required this.editModeContent,
    required this.normalModeContent,
    required this.selectModeContent,
    this.onItemSwipe,
  });

  get text => null;

  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  final ThemeController themeController = Get.find();
  late Color backgroundColor;
  late Color textColor;

  Future<bool> handleSwipe(DismissDirection direction) async {
    if (direction == DismissDirection.startToEnd) {
      return true;
    } else if (direction == DismissDirection.endToStart) {
      widget.onItemEditModeSwipe();
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == DataFieldMode.edit) {
      backgroundColor = themeController.theme.ligtherMainColor;
      textColor = Colors.white.withOpacity(0.6);
    } else {
      textColor = Colors.black;
      backgroundColor = themeController.theme.mainColor
          .withOpacity(widget.isDarker ? 0.04 : 0.0);
    }
  }

  Widget get dataFieldContent {
    switch (widget.mode) {
      case DataFieldMode.edit:
        return widget.editModeContent;
      case DataFieldMode.select:
        return widget.selectModeContent;
      default:
        return widget.normalModeContent;
    }
  }

  get swipableDataFieldContent => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) => widget.onItemDismissSwipe(),
        confirmDismiss: handleSwipe,
        background: getFieldSwipeBackground(
          Icons.close,
          redToTransparentGradient,
          Alignment.centerLeft,
        ),
        secondaryBackground: getFieldSwipeBackground(
          widget.mode == DataFieldMode.edit ? Icons.edit_off : Icons.edit,
          transparentToGoldGradient,
          Alignment.centerRight,
        ),
        child: dataFieldContent,
      );

  Widget getFieldSwipeBackground(final IconData iconData,
          final LinearGradient gradient, Alignment alignment) =>
      Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: widget.model.value != null ? 8.0 : 0.0,
            bottom: widget.model.value != null ? 8.0 : 0.0,
          ),
          child: Icon(iconData),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return swipableDataFieldContent;
  }
}
