import 'package:flutter/material.dart';

class SelectModeEditorOption {
  final String label;
  final IconData icon;
  final VoidCallback onSelected;

  SelectModeEditorOption({
    required this.label,
    required this.icon,
    required this.onSelected,
  });
}

class DataEditorTopBar extends StatelessWidget {
  final VoidCallback onResized;
  final VoidCallback onAddObject;
  final Color background;
  final List<SelectModeEditorOption> selectModeOptions;
  final bool selectMode;
  final TextEditingController titleEditingController;
  final Function(String) onTitleChanged;

  const DataEditorTopBar({
    super.key,
    required this.onResized,
    required this.background,
    required this.onAddObject,
    required this.selectModeOptions,
    required this.selectMode,
    required this.titleEditingController,
    required this.onTitleChanged,
  });

  get popupMenu => PopupMenuButton<SelectModeEditorOption>(
        color: background,
        onSelected: (SelectModeEditorOption value) => value.onSelected(),
        itemBuilder: (context) => selectModeOptions
            .map(
              (option) => PopupMenuItem<SelectModeEditorOption>(
                value: option,
                child: Row(
                  children: [
                    Icon(option.icon),
                    const SizedBox(width: 8),
                    Text(option.label),
                  ],
                ),
              ),
            )
            .toList(),
        child: const Icon(Icons.menu),
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
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: TextField(
              controller: titleEditingController,
              onChanged: onTitleChanged,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                  isDense: true, border: InputBorder.none),
            ),
          )),
          if (selectMode)
            Padding(padding: const EdgeInsets.all(12.0), child: popupMenu)
          else
            IconButton(
              iconSize: 20,
              onPressed: onAddObject,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
    );
  }
}
