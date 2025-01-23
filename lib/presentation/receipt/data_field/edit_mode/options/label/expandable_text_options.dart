import 'package:flutter/material.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_option_panel.dart';

class DataFieldTextOptions extends StatefulWidget {
  const DataFieldTextOptions({
    super.key,
    required this.onChangedToValue,
    required this.onCollapse,
    required this.constraints,
    required this.isExpanded,
    required this.buttonColor,
    required this.foregroundColor,
    required this.iconColor,
    this.onChangedToInfo,
    this.onChangedToProduct,
  });

  final VoidCallback? onChangedToValue;
  final VoidCallback? onChangedToInfo;
  final VoidCallback? onChangedToProduct;
  final VoidCallback onCollapse;
  final BoxConstraints constraints;
  final bool isExpanded;
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

  List<Widget> get options {
    List<Widget> opts = [separator];
    if (widget.onChangedToValue != null) {
      opts += [
        ExpandableButton(
          onPressed: widget.onChangedToValue!,
          iconData: Icons.transform,
          iconColor: widget.foregroundColor,
          buttonColor: widget.buttonColor,
          label: 'To Value',
        ),
        separator,
      ];
    }
    if (widget.onChangedToInfo != null) {
      opts += [
        ExpandableButton(
          onPressed: widget.onChangedToInfo!,
          iconData: Icons.info_outline,
          iconColor: widget.foregroundColor,
          buttonColor: widget.buttonColor,
          label: 'To Info',
        ),
        separator,
      ];
    }
    if (widget.onChangedToProduct != null) {
      opts += [
        ExpandableButton(
          onPressed: widget.onChangedToProduct!,
          iconData: Icons.price_change_outlined,
          iconColor: widget.foregroundColor,
          buttonColor: widget.buttonColor,
          label: 'To Product',
        ),
        separator,
      ];
    }

    return opts;
  }

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
