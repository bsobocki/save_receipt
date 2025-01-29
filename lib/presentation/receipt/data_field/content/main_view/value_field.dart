import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';

const dropdownmenuHeight = 300.0;

class ValueField extends StatefulWidget {
  const ValueField({
    super.key,
    required this.initValue,
    required this.values,
    required this.onValueChanged,
    required this.textColor,
    required this.enabled,
  });

  final String initValue;
  final List<dynamic> values;
  final Function(String? value) onValueChanged;
  final Color textColor;
  final bool enabled;

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  bool showMenu = false;
  final TextEditingController menuController = TextEditingController();
  final TextEditingController textFieldController = TextEditingController();
  final ThemeController themeController = Get.find();
  late final List<String> initialValues;
  late List<String> values;

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
        enabled: widget.enabled,
        menuHeight: dropdownmenuHeight,
        enableSearch: true,
        requestFocusOnTap: true,
        controller: menuController,
        leadingIcon: null,
        expandedInsets: EdgeInsets.zero,
        inputDecorationTheme: InputDecorationTheme(
          constraints: const BoxConstraints(maxWidth: 200.0, maxHeight: 30.0),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixIconColor: themeController.theme.mainColor,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        textStyle: TextStyle(
          color: widget.textColor,
          fontSize: 12.0,
        ),
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
        backgroundColor:
            WidgetStatePropertyAll(themeController.theme.mainColor),
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
