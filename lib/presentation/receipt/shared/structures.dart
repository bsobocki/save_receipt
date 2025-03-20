
import 'package:flutter/material.dart';

class SelectionModeEditorOption {
  final String label;
  final IconData icon;
  final VoidCallback onSelected;

  SelectionModeEditorOption({
    required this.label,
    required this.icon,
    required this.onSelected,
  });
}