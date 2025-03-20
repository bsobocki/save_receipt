import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/select_mode/data_text_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/edit_mode/data_field_edit_mode_label_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/edit_mode/data_fiels_edit_mode_value_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/main_view/label_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/main_view/value_field.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/shared/enums.dart';

class InfoDataField extends StatefulWidget {
  final ReceiptObjectModel model;
  final AllValuesModel allValuesData;
  final DataFieldMode mode;
  final bool isDarker;
  final bool selected;
  final Function() onItemDismissSwipe;
  final Function() onItemEditModeSwipe;
  final Function(DismissDirection direction)? onItemSwipe;
  final Function()? onChangedToValue;
  final Function()? onChangedToProduct;
  final Function()? onChangedToInfo;
  final Function()? onValueToFieldChanged;
  final Function(ReceiptObjectModelType)? onValueTypeChanged;
  final VoidCallback? onChangedData;
  final VoidCallback onSelected;
  final VoidCallback onLongPress;

  const InfoDataField({
    super.key,
    required this.model,
    required this.allValuesData,
    required this.mode,
    required this.isDarker,
    required this.onItemDismissSwipe,
    required this.onItemEditModeSwipe,
    this.onChangedToValue,
    this.onItemSwipe,
    this.onValueToFieldChanged,
    this.onValueTypeChanged,
    this.onChangedToProduct,
    this.onChangedToInfo,
    this.onChangedData,
    required this.selected,
    required this.onSelected,
    required this.onLongPress,
  });

  get text => null;

  @override
  State<InfoDataField> createState() => _InfoDataFieldState();
}

class _InfoDataFieldState extends State<InfoDataField> {
  TextEditingController textController = TextEditingController();
  final ThemeController themeController = Get.find();

  Set<String> allValuesForType(ReceiptObjectModelType type) {
    switch (type) {
      case ReceiptObjectModelType.infoDouble:
        return widget.allValuesData.prices;
      case ReceiptObjectModelType.infoTime:
        return widget.allValuesData.time;
      case ReceiptObjectModelType.infoText:
        return widget.allValuesData.info;
      default:
        return {};
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

  Widget get selectionModeContent {
    double opacity = widget.isDarker ? 0.06 : 0.0;
    Color foregroundColor = Colors.black;
    if (widget.selected) {
      opacity += 0.9;
      foregroundColor = Colors.white.withOpacity(0.9);
    }

    return GestureDetector(
      onTap: widget.onSelected,
      onLongPress: widget.onLongPress,
      child: Container(
        color: themeController.theme.mainColor.withOpacity(opacity),
        child: Column(
          children: [
            SelectionModeDataTextField(
              text: widget.model.text,
              textColor: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
            if (widget.model.value != null)
              SelectionModeDataTextField(
                text: widget.model.value!,
                textAlign: TextAlign.right,
                textColor: foregroundColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget get normalModeContent => GestureDetector(
        onLongPress: widget.onLongPress,
        child: Container(
          color: themeController.theme.mainColor
              .withOpacity(widget.isDarker ? 0.04 : 0.0),
          child: Column(
            children: [
              DataTextField(
                textController: textController,
                onChanged: (String value) {
                  widget.model.text = value;
                  widget.onChangedData?.call();
                },
              ),
              if (widget.model.value != null)
                ValueField(
                  textColor: Colors.black,
                  initValue: widget.model.value ?? '',
                  values: allValuesForType(widget.model.type),
                  compareItems:
                      widget.model.type == ReceiptObjectModelType.infoDouble
                          ? (String a, String b) =>
                              double.parse(a).compareTo(double.parse(b))
                          : null,
                  onValueChanged: (String? value) {
                    widget.model.value = value;
                    widget.onChangedData?.call();
                  },
                ),
            ],
          ),
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
      mode: widget.mode,
      isDarker: widget.isDarker,
      onItemDismissSwipe: widget.onItemDismissSwipe,
      onItemEditModeSwipe: widget.onItemEditModeSwipe,
      editModeContent: editModeContent,
      normalModeContent: normalModeContent,
      selectionModeContent: selectionModeContent,
    );
  }
}
