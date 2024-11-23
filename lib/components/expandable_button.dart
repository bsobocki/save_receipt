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
  });

  final String label;
  final Color buttonColor;
  final IconData iconData;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? textColor;

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool expanded = false;
  final Color defaultFrontColor = Colors.white;

  get iconColor => widget.iconColor ?? defaultFrontColor;
  get textColor => widget.textColor ?? defaultFrontColor;

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return CircleAvatar(
        backgroundColor: widget.buttonColor,
        child: IconButton(
          onPressed: () => setState(() {
            expanded = true;
          }),
          icon: Icon(widget.iconData, color: widget.iconColor),
          color: iconColor,
        ),
      );
    }

    return TapRegion(
      onTapOutside: (event) {
        setState(() => expanded = false);
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(), // This creates the pill shape
          backgroundColor: widget.buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () {
          widget.onPressed();
          setState(() => expanded = false);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.iconData,
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
