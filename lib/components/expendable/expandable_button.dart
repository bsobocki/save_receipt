import 'package:flutter/material.dart';

class ExpandableButton extends StatefulWidget {
  const ExpandableButton({
    super.key,
    required this.buttonColor,
    required this.iconData,
    required this.onPressed,
    this.iconColor,
    this.textColor,
    required this.label,
    this.constraints,
    this.wrapText = false,
  });

  final String label;
  final Color buttonColor;
  final IconData iconData;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? textColor;
  final BoxConstraints? constraints;
  final bool wrapText;

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool expanded = false;
  final Color defaultFrontColor = Colors.white;

  get iconColor => widget.iconColor ?? defaultFrontColor;
  get textColor => widget.textColor ?? defaultFrontColor;

  get label {
    Widget labelWidget = Text(
      widget.label,
      style: TextStyle(color: textColor),
      overflow: TextOverflow.ellipsis,
    );
    if (widget.wrapText) {
      return Expanded(child: labelWidget);
    }
    return labelWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;

    if (!expanded) {
      content = CircleAvatar(
        backgroundColor: widget.buttonColor,
        child: IconButton(
          onPressed: () => setState(() {
            expanded = true;
          }),
          icon: Icon(widget.iconData, color: widget.iconColor),
          color: iconColor,
        ),
      );
    } else {
      content = TapRegion(
        onTapOutside: (event) {
          setState(() => expanded = false);
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            //shape: const StadiumBorder(), // This creates the pill shape
            backgroundColor: widget.buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: () {
            widget.onPressed();
            setState(() => expanded = false);
          },
          child: Row(
            children: [
              Icon(
                widget.iconData,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              label,
            ],
          ),
        ),
      );
    }

    return Container(constraints: widget.constraints, child: content);
  }
}
