import 'package:flutter/material.dart';

const double iconButtonSize = 48;

class ExpandableOptionsPanel extends StatefulWidget {
  const ExpandableOptionsPanel({
    super.key,
    required this.options,
    required this.onCollapse,
    required this.constraints,
    required this.alignment,
    this.isExpanded = false,
    this.buttonColor = Colors.black,
    this.iconColor = Colors.white,
  });

  final VoidCallback onCollapse;
  final BoxConstraints constraints;
  final bool isExpanded;
  final List<Widget> options;
  final Color? buttonColor;
  final Color? iconColor;
  final MainAxisAlignment alignment;

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

  get iconData {
    if (widget.alignment == MainAxisAlignment.start) {
      return isExpanded
          ? Icons.arrow_left_outlined
          : Icons.arrow_right_outlined;
    }
    return isExpanded ? Icons.arrow_right_outlined : Icons.arrow_left_outlined;
  }

  get expandingButton => IconButton(
        icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.buttonColor,
            ),
            child: Icon(
              iconData,
              color: widget.iconColor,
            )),
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
      );

  get panelAlignment {
    if (widget.alignment == MainAxisAlignment.start) {
      return MainAxisAlignment.end;
    }
    return MainAxisAlignment.start;
  }

  Widget optionPanel(double expandedOptionsWidth) => AnimatedContainer(
        width: expandedOptionsWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: widget.alignment,
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

    List<Widget> content = [
      expandingButton,
      optionPanel(expandedOptionPanelWidth),
    ];

    if (widget.alignment == MainAxisAlignment.start) {
      content = [
        optionPanel(expandedOptionPanelWidth),
        expandingButton,
      ];
    }

    return Container(
      constraints: BoxConstraints(maxWidth: widgetWidth),
      child: ClipRect(
        child: Row(
          mainAxisAlignment: widget.alignment,
          children: content,
        ),
      ),
    );
  }
}
