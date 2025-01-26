import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/core/themes/styles/colors.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_option_panel.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/options/value/buttons/add_remove_value_button.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/options/value/buttons/value_type_menu.dart';

const double iconButtonSize = 48;

class ExpandableValueOptions extends StatefulWidget {
  const ExpandableValueOptions({
    super.key,
    required this.onRemoveValue,
    required this.onAddValue,
    required this.onCollapse,
    required this.valueExists,
    required this.onValueTypeChanged,
    required this.constraints,
    required this.initType,
    required this.onValueToFieldChange,
    this.isExpanded = false,
  });

  final VoidCallback? onRemoveValue;
  final VoidCallback onAddValue;
  final VoidCallback onCollapse;
  final VoidCallback? onValueToFieldChange;
  final Function(ReceiptObjectModelType)? onValueTypeChanged;
  final ReceiptObjectModelType initType;
  final BoxConstraints constraints;
  final bool valueExists;
  final bool isExpanded;

  @override
  State<ExpandableValueOptions> createState() => _ExpandableValueOptionsState();
}

class _ExpandableValueOptionsState extends State<ExpandableValueOptions> {
  final ThemeController themeController = Get.find();
  late bool isExpanded;
  get separator => const SizedBox(width: 16);

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  get options {
    List<Widget> optionButtons = [separator];

    if (widget.onRemoveValue != null) {
      optionButtons += [
        DataFieldAddRemoveValueButton(
          valueExists: widget.valueExists,
          removeButtonForegroundColor: redButtonColor,
          addButtonForegroundColor: greenButtonColor,
          onRemoveValue: widget.onRemoveValue!,
          onAddValue: widget.onAddValue,
          buttonColor: themeController.theme.mainColor,
        ),
        separator,
      ];
    }

    if (widget.onValueTypeChanged != null) {
      optionButtons += [
        DataFieldValueTypeMenu(
          color: goldButtonColor,
          type: widget.initType,
          onTypeChanged: widget.onValueTypeChanged,
          buttonColor: themeController.theme.mainColor,
        ),
        separator,
      ];
    }

    if (widget.valueExists && widget.onValueToFieldChange != null) {
      optionButtons += [
        ExpandableButton(
          label: 'Value As New Item',
          textColor: Colors.white,
          iconData: Icons.swap_horiz_outlined,
          iconColor: greyButtonColor,
          buttonColor: themeController.theme.mainColor,
          onPressed: widget.onValueToFieldChange!,
        ),
        separator,
      ];
    }

    return optionButtons;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableOptionsPanel(
      alignment: MainAxisAlignment.start,
      options: options,
      onCollapse: widget.onCollapse,
      constraints: widget.constraints,
      isExpanded: isExpanded,
      iconColor: themeController.theme.mainColor,
      buttonColor: Colors.white,
    );
  }
}
