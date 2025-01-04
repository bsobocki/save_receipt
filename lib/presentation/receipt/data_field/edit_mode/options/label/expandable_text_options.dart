import 'package:flutter/material.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_option_panel.dart';

class DataFieldTextOptions extends StatefulWidget {
  const DataFieldTextOptions({
    super.key,
    required this.onChangeToValue,
    required this.onCollapse,
    required this.constraints,
    required this.isExpanded,
    required this.onFieldToValueChanged,
    required this.buttonColor,
    required this.foregroundColor, required this.iconColor,
  });

  final VoidCallback onChangeToValue;
  final VoidCallback onCollapse;
  final BoxConstraints constraints;
  final bool isExpanded;
  final VoidCallback onFieldToValueChanged;
  final Color buttonColor;
  final Color foregroundColor;
  final Color iconColor;

  @override
  State<DataFieldTextOptions> createState() => _DataFieldOptionsState();
}

class _DataFieldOptionsState extends State<DataFieldTextOptions> {
  bool isExpanded = false;
  get separator => const SizedBox(width: 16);

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  List<Widget> get options => [
        separator,
        ExpandableButton(
          onPressed: widget.onChangeToValue,
          iconData: Icons.transform,
          iconColor: widget.foregroundColor,
          buttonColor: widget.buttonColor,
          label: 'Item To Value',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return ExpandableOptionsPanel(
      alignment: MainAxisAlignment.end,
      options: options,
      onCollapse: widget.onCollapse,
      constraints: widget.constraints,
      isExpanded: isExpanded,
      iconColor: widget.iconColor,
      buttonColor: Colors.white,
    );
  }
}
