import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/edit_mode/data_field_edit_mode_label_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/edit_mode/data_fiels_edit_mode_value_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/main_view/label_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/main_view/value_field.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

class InfoDataField extends StatefulWidget {
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
  final VoidCallback? onChangedData;

  const InfoDataField({
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
    this.onChangedData,
  });

  get text => null;

  @override
  State<InfoDataField> createState() => _InfoDataFieldState();
}

class _InfoDataFieldState extends State<InfoDataField> {
  TextEditingController textController = TextEditingController();
  final ThemeController themeController = Get.find();

  List<String> allValuesForType(ReceiptObjectModelType type) {
    switch (type) {
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

  @override
  void initState() {
    super.initState();
    textController.text = widget.model.text;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Widget get normalModeContent => Container(
        color: themeController.theme.mainColor
            .withOpacity(widget.isDarker ? 0.04 : 0.0),
        child: Column(
          children: [
            DataTextField(
              enabled: widget.enabled,
              textController: textController,
              onChanged: (String value) {
                widget.model.text = value;
                widget.onChangedData?.call();
              },
            ),
            if (widget.model.value != null)
              ValueField(
                enabled: widget.enabled,
                textColor: Colors.black,
                initValue: widget.model.value ?? '',
                values: allValuesForType(widget.model.type),
                onValueChanged: (String? value) {
                  widget.model.value = value;
                  widget.onChangedData?.call();
                },
              ),
          ],
        ),
      );

  Widget get editModeContent => Container(
        color: themeController.theme.ligtherMainColor,
        child: Column(children: [
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
            onValueStateChanged: widget.onChangedData,
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return DataField(
        model: widget.model,
        allValuesData: widget.allValuesData,
        isInEditMode: widget.isInEditMode,
        isDarker: widget.isDarker,
        enabled: widget.enabled,
        onItemDismissSwipe: widget.onItemDismissSwipe,
        onItemEditModeSwipe: widget.onItemEditModeSwipe,
        editModeContent: editModeContent,
        normalModeContent: normalModeContent);
  }
}
