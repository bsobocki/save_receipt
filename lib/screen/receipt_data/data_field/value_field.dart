import 'package:flutter/material.dart';

const dropdownmenuHeight = 300.0;

class ValueField extends StatefulWidget {
  const ValueField({
    super.key,
    required this.initValue,
    required this.values,
    required this.onSelected,
  });

  final String initValue;
  final List<String> values;
  final Function(String? value) onSelected;

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  bool showMenu = false;
  final TextEditingController menuController = TextEditingController();
  final TextEditingController textFieldController = TextEditingController();

  @override
  void initState() {
    textFieldController.text = widget.initValue;
    super.initState();
  }

  void switchView() => setState(() => showMenu = !showMenu);

  get textFieldView => Expanded(
        child: TextField(
          controller: textFieldController,
          onSubmitted: widget.onSelected,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      );

  get dropdownMenu => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: DropdownMenu<String>(
          // todo: filtering without error when nothjing found - custon filtering
          // enableFilter: true,
          menuHeight: dropdownmenuHeight,
          enableSearch: true,
          requestFocusOnTap: true,
          controller: menuController,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.black,
            suffixIconColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
          textStyle: menuTextStyle,
          menuStyle: menuStyle,
          onSelected: (value) {
            String newValue = value ?? menuController.text;
            textFieldController.text = newValue;
            switchView();
            widget.onSelected(newValue);
          },
          dropdownMenuEntries: menuEntries,
        ),
      );

  get menuStyle => const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black),
        shadowColor: WidgetStatePropertyAll(
          Color.fromARGB(193, 0, 0, 0),
        ),
        surfaceTintColor: WidgetStatePropertyAll(Colors.white),
      );

  get menuTextStyle => const TextStyle(color: Colors.white);

  get menuEntries =>
      widget.values.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList();

  get menuButton => IconButton(
        onPressed: () {
          menuController.text = textFieldController.text;
          switchView();
        },
        icon: const Icon(
          Icons.arrow_drop_down_circle,
          color: Colors.black,
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [Expanded(child: Container())];

    if (showMenu) {
      elements.add(dropdownMenu);
    } else {
      elements.add(textFieldView);
      elements.add(menuButton);
    }
    return Row(
      children: elements,
    );
  }
}
