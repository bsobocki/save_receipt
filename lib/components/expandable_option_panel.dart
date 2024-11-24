import 'package:flutter/material.dart';

const double iconButtonSize = 48;

class ExpandableOptionsPanel extends StatefulWidget {
  const ExpandableOptionsPanel({
    super.key,
    required this.options,
    required this.onCollapse,
    required this.constraints,
    this.isExpanded = false,
    this.buttonColor = Colors.black, this.iconColor = Colors.white,
  });

  final VoidCallback onCollapse;
  final BoxConstraints constraints;
  final bool isExpanded;
  final List<Widget> options;
  final Color? buttonColor;
  final Color? iconColor;

  @override
  State<ExpandableOptionsPanel> createState() => _ExpandableOptionsPanelState();
}

class _ExpandableOptionsPanelState extends State<ExpandableOptionsPanel> {
  late bool isExpanded;
  get separator => const SizedBox(width: 16);

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  get expandingButton => IconButton(
        icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.buttonColor,
            ),
            child: Icon(
              isExpanded
                  ? Icons.arrow_right_outlined
                  : Icons.arrow_left_outlined,
              color: widget.iconColor,
            )),
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
      );

  Widget optionPanel(double expandedOptionsWidth) => AnimatedContainer(
        width: expandedOptionsWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.options,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double expandedOptionPanelWidth =
        isExpanded ? widget.constraints.maxWidth - iconButtonSize : 0.0;
    double widgetWidth =
        isExpanded ? widget.constraints.maxWidth : iconButtonSize;

    return Container(
      constraints: BoxConstraints(maxWidth: widgetWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          expandingButton,
          optionPanel(expandedOptionPanelWidth),
        ],
      ),
    );
  }
}
