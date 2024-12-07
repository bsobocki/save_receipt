import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/main_theme.dart';

const dropdownmenuHeight = 300.0;

class ValueField extends StatefulWidget {
  const ValueField({
    super.key,
    required this.initValue,
    required this.values,
    required this.onValueChanged,
    required this.textColor,
  });

  final String initValue;
  final List<dynamic> values;
  final Function(String? value) onValueChanged;
  final Color textColor;

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  bool showMenu = false;
  final TextEditingController menuController = TextEditingController();
  final TextEditingController textFieldController = TextEditingController();
  late final List<dynamic> initialValues;
  late List<dynamic> values;

  @override
  void initState() {
    menuController.text = widget.initValue;
    initialValues = List.from(widget.values)..sort();
    values = initialValues;
    menuController.addListener(() {
      setState(() {
        if (menuController.text.isNotEmpty) {
          final String trimmedFilter = menuController.text.trim().toLowerCase();
          values = initialValues
              .where(
                (element) =>
                    element.toString().toLowerCase().contains(trimmedFilter),
              )
              .toList();
        } else {
          values = initialValues;
        }
        widget.onValueChanged(menuController.text);
      });
    });

    super.initState();
  }

  get dropdownMenu => DropdownMenu<dynamic>(
        menuHeight: dropdownmenuHeight,
        enableSearch: true,
        requestFocusOnTap: true,
        controller: menuController,
        inputDecorationTheme: InputDecorationTheme(
            suffixIconColor: mainTheme.mainColor,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
        textStyle: TextStyle(color: widget.textColor),
        menuStyle: menuStyle,
        onSelected: (value) {
          String newValue = value?.toString() ?? menuController.text;
          textFieldController.text = newValue;
          widget.onValueChanged(newValue);
        },
        dropdownMenuEntries: menuEntries,
        textAlign: TextAlign.right,
      );

  get menuStyle => MenuStyle(
        backgroundColor: WidgetStatePropertyAll(mainTheme.mainColor),
        shadowColor: const WidgetStatePropertyAll(
          Color.fromARGB(193, 0, 0, 0),
        ),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
      );

  get menuEntries => values.map<DropdownMenuEntry<dynamic>>((value) {
        return DropdownMenuEntry<dynamic>(
            value: value, label: value.toString());
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Container()),
      dropdownMenu,
    ]);
  }
}
