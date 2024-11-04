import 'package:flutter/material.dart';

class ValueField extends StatefulWidget {
  const ValueField({
    super.key,
    required this.defaultValue,
    required this.values,
    required this.onSelected,
    required this.controller,
  });

  final String defaultValue;
  final List<String> values;
  final Function(String? value) onSelected;
  final TextEditingController controller;

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // child: TextField(
          //   controller: widget.controller,
          //   onSubmitted: widget.onSelected,
          //   style: TextStyle(color: Colors.blueGrey),
          // ),
          child: Container(),
        ),
        DropdownMenu<String>(
          label: Text('ugabugaaa'),
          // todo: filtering without error when nothjing found - custon filtering
          // enableFilter: true,
          enableSearch: true,
          requestFocusOnTap: true,
          controller: widget.controller,
          inputDecorationTheme: InputDecorationTheme(
            iconColor: Colors.blueGrey,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
          textStyle: TextStyle(color: Colors.blueGrey),
          menuStyle: MenuStyle(
            shadowColor: WidgetStatePropertyAll(
              const Color.fromARGB(193, 0, 0, 0),
            ),
            surfaceTintColor: WidgetStatePropertyAll(Colors.black),
          ),
          initialSelection: widget.values.first,
          onSelected: (value) {
            String _value = widget.controller.text;
            if (value != null) {
              _value = value;
            }
            widget.onSelected(_value);
          },
          dropdownMenuEntries:
              widget.values.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ],
    );
    ;
  }
}
