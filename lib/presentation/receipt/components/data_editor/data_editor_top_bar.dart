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
  final bool isExpanded;
  final VoidCallback onResized;
  final VoidCallback onAddObject;
  final Color background;
  final String title;
  final List<SelectModeEditorOption> selectModeOptions;
  final bool selectMode;

  const DataEditorTopBar({
    super.key,
    required this.isExpanded,
    required this.onResized,
    required this.background,
    required this.title,
    required this.onAddObject,
    required this.selectModeOptions,
    required this.selectMode,
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
    return GestureDetector(
      onTap: onResized,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        width: double.infinity,
        //height: 30.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(child: Container()),
            if (isExpanded && selectMode)
              Padding(padding: const EdgeInsets.all(12.0), child: popupMenu)
            else
              IconButton(
                iconSize: 20,
                onPressed: !isExpanded ? null : onAddObject,
                icon: Icon(
                  isExpanded ? Icons.add : Icons.radio_button_off,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
