import 'package:flutter/material.dart';
import 'package:save_receipt/presentation/receipt/shared/structures.dart';

class DataEditorTopBar extends StatelessWidget {
  final VoidCallback onResized;
  final VoidCallback onAddObject;
  final Color background;
  final List<SelectionModeEditorOption> selectionModeOptions;
  final bool selectionMode;
  final TextEditingController titleEditingController;
  final Function(String) onTitleChanged;

  const DataEditorTopBar({
    super.key,
    required this.onResized,
    required this.background,
    required this.onAddObject,
    required this.selectionModeOptions,
    required this.selectionMode,
    required this.titleEditingController,
    required this.onTitleChanged,
  });

  get popupMenu => Padding(
        padding: const EdgeInsets.all(12.0),
        child: PopupMenuButton<SelectionModeEditorOption>(
          color: background,
          onSelected: (SelectionModeEditorOption value) => value.onSelected(),
          itemBuilder: (context) => selectionModeOptions
              .map(
                (option) => PopupMenuItem<SelectionModeEditorOption>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(option.icon),
                      const SizedBox(width: 8),
                      Text(
                        option.label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          child: const Icon(Icons.menu),
        ),
      );

  Widget get titleEditor => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
          child: TextField(
            controller: titleEditingController,
            onChanged: onTitleChanged,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            cursorColor: Colors.white,
            decoration:
                const InputDecoration(isDense: true, border: InputBorder.none),
          ),
        ),
      );

  Widget get addObjectButton => IconButton(
        iconSize: 20,
        onPressed: onAddObject,
        icon: const Icon(Icons.add),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      width: double.infinity,
      height: 40.0,
      child: Row(
        children: [
          titleEditor,
          if (selectionMode) popupMenu else addObjectButton,
        ],
      ),
    );
  }
}
