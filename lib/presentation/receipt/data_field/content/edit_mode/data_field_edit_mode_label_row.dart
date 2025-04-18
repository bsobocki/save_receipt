import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/core/themes/styles/colors.dart';
import 'package:save_receipt/presentation/receipt/components/options/label/expandable_text_options.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/edit_mode/text/data_field_text.dart';

class DataFieldEditModeTextRow extends StatefulWidget {
  const DataFieldEditModeTextRow({
    super.key,
    required this.model,
    required this.onFieldToValueChanged,
    required this.textColor,
    this.onChangedToInfo,
    this.onChangedToProduct,
  });

  final Color textColor;
  final ReceiptObjectModel model;
  final VoidCallback? onFieldToValueChanged;
  final VoidCallback? onChangedToInfo;
  final VoidCallback? onChangedToProduct;

  @override
  State<DataFieldEditModeTextRow> createState() =>
      _DataFieldEditModeTextRowState();
}

class _DataFieldEditModeTextRowState extends State<DataFieldEditModeTextRow> {
  final ThemeController themeController = Get.find();
  bool expandedOptions = false;

  Widget expandableOptionsButtons(BoxConstraints constraints) =>
      DataFieldTextOptions(
        key: UniqueKey(),
        constraints: constraints,
        isExpanded: expandedOptions,
        onChangedToValue: widget.onFieldToValueChanged,
        onChangedToInfo: widget.onChangedToInfo,
        onCollapse: () {},
        buttonColor: themeController.theme.mainColor,
        foregroundColor: greyButtonColor,
        iconColor: themeController.theme.mainColor,
        onChangedToProduct: widget.onChangedToProduct,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      child: Row(children: [
        if (!expandedOptions)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: DataFieldEditModeText(
                text: widget.model.text, textColor: widget.textColor),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) =>
                expandableOptionsButtons(constraints),
          ),
        ),
      ]),
    );
  }
}
