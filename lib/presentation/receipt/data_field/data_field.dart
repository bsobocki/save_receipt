import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/gradients/main_gradients.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

class DataField extends StatefulWidget {
  final bool enabled;
  final bool isDarker;
  final bool isInEditMode;
  final Widget editModeContent;
  final Widget normalModeContent;
  final ReceiptObjectModel model;
  final AllValuesModel allValuesData;
  final Function() onItemDismissSwipe;
  final Function() onItemEditModeSwipe;
  final Function(DismissDirection direction)? onItemSwipe;

  const DataField({
    super.key,
    required this.model,
    required this.allValuesData,
    required this.isInEditMode,
    required this.isDarker,
    required this.enabled,
    required this.onItemDismissSwipe,
    required this.onItemEditModeSwipe,
    required this.editModeContent,
    required this.normalModeContent,
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
    if (widget.isInEditMode) {
      backgroundColor = themeController.theme.ligtherMainColor;
      textColor = Colors.white.withOpacity(0.6);
    } else {
      textColor = Colors.black;
      backgroundColor = themeController.theme.mainColor
          .withOpacity(widget.isDarker ? 0.04 : 0.0);
    }
  }

  Widget get dataFieldContent => widget.isInEditMode
            ? widget.editModeContent
            : widget.normalModeContent;

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
          widget.isInEditMode ? Icons.edit_off : Icons.edit,
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
    return widget.enabled ? swipableDataFieldContent : dataFieldContent;
  }
}
