import 'package:flutter/material.dart';

class DataEditorTopBar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onResizeButtonPressed;
  final Color background;
  final String title;

  const DataEditorTopBar({
    super.key,
    required this.isExpanded,
    required this.onResizeButtonPressed,
    required this.background,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      width: double.infinity,
      height: 30.0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(child: Container()),
          IconButton(
            onPressed: onResizeButtonPressed,
            iconSize: 18,
            icon: Icon(
                isExpanded ? Icons.radio_button_on : Icons.radio_button_off),
          ),
        ],
      ),
    );
  }
}
