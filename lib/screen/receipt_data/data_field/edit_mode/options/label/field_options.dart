import 'package:flutter/material.dart';
import 'package:save_receipt/color/colors.dart';

class DataFieldOptions extends StatefulWidget {
  const DataFieldOptions({super.key, required this.onChangeToValue});

  final VoidCallback onChangeToValue;

  @override
  State<DataFieldOptions> createState() => _DataFieldOptionsState();
}

class _DataFieldOptionsState extends State<DataFieldOptions> {
  get changeItemToValueButton => IconButton(
        onPressed: widget.onChangeToValue,
        icon: const Icon(Icons.transform, color: darkGreen),
      );
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
