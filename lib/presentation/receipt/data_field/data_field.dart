import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/gradients/main_gradients.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/data_field_edit_mode_label_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/data_fiels_edit_mode_value_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/main_view/label_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/main_view/value_field.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

class DataField extends StatefulWidget {
  final ReceiptObjectModel model;
  final AllValuesModel allValuesData;
  final bool isInEditMode;
  final bool isDarker;
  final bool enabled;
  final Function() onItemDismissSwipe;
  final Function() onItemEditModeSwipe;
  final Function(DismissDirection direction)? onItemSwipe;
  final Function()? onChangedToValue;
  final Function()? onChangedToProduct;
  final Function()? onChangedToInfo;
  final Function()? onValueToFieldChanged;
  final Function(ReceiptObjectModelType)? onValueTypeChanged;

  const DataField({
    super.key,
    required this.model,
    required this.allValuesData,
    required this.isInEditMode,
    required this.isDarker,
    required this.enabled,
    required this.onItemDismissSwipe,
    required this.onItemEditModeSwipe,
    this.onChangedToValue,
    this.onItemSwipe,
    this.onValueToFieldChanged,
    this.onValueTypeChanged,
    this.onChangedToProduct,
    this.onChangedToInfo,
  });

  get text => null;

  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  TextEditingController textController = TextEditingController();
  final ThemeController themeController = Get.find();
  late Color backgroundColor;
  late Color textColor;

  List<String> allValuesForType(ReceiptObjectModelType type) {
    switch (type) {
      case ReceiptObjectModelType.product:
      case ReceiptObjectModelType.infoDouble:
        return widget.allValuesData.prices;
      case ReceiptObjectModelType.infoDate:
        return widget.allValuesData.dates;
      case ReceiptObjectModelType.infoText:
        return widget.allValuesData.info;
      default:
        return [];
    }
  }

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
    textController.text = widget.model.text;
    if (widget.isInEditMode) {
      backgroundColor = themeController.theme.ligtherMainColor;
      textColor = Colors.white.withOpacity(0.6);
    } else {
      textColor = Colors.black;
      backgroundColor = themeController.theme.mainColor
          .withOpacity(widget.isDarker ? 0.04 : 0.0);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  get dataFieldContent {
    List<Widget> columnContent = [];

    if (widget.isInEditMode) {
      columnContent = [
        DataFieldEditModeTextRow(
          model: widget.model,
          onFieldToValueChanged: widget.onChangedToValue,
          textColor: themeController.theme.extraLightMainColor,
          onChangedToInfo: widget.onChangedToInfo,
          onChangedToProduct: widget.onChangedToProduct,
        ),
        DataFieldEditModeValueRow(
          model: widget.model,
          onValueToFieldChanged: widget.onValueToFieldChanged,
          onValueTypeChanged: widget.onValueTypeChanged,
          textColor: themeController.theme.extraLightMainColor,
        ),
      ];
    } else {
      columnContent = [
        DataTextField(
          enabled: widget.enabled,
          textController: textController,
          onChanged: (String value) => widget.model.text = value,
        ),
        if (widget.model.value != null)
          ValueField(
            enabled: widget.enabled,
            textColor: textColor,
            initValue: widget.model.value ?? '',
            values: allValuesForType(widget.model.type),
            onValueChanged: (String? value) => widget.model.value = value,
          ),
      ];
    }

    Widget dataFieldWidget = Container(
      color: backgroundColor,
      child: Column(children: columnContent),
    );

    return dataFieldWidget;
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
