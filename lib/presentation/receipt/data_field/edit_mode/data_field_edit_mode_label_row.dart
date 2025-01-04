import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/core/themes/styles/colors.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/options/label/expandable_text_options.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/text/label_text.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

class DataFieldEditModeTextRow extends StatefulWidget {
  const DataFieldEditModeTextRow({
    super.key,
    required this.model,
    required this.onFieldToValueChanged, required this.textColor,
  });

  final Color textColor;
  final ReceiptObjectModel model;
  final VoidCallback onFieldToValueChanged;

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
        onFieldToValueChanged: widget.onFieldToValueChanged,
        isExpanded: expandedOptions,
        onChangeToValue: widget.onFieldToValueChanged,
        onCollapse: () {},
        buttonColor: themeController.theme.mainColor,
        foregroundColor: greyButtonColor,
        iconColor: themeController.theme.mainColor,
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
                text: widget.model.text,
                textColor: widget.textColor),
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
