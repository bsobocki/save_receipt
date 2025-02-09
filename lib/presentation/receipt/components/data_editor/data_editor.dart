import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor_top_bar.dart';

class ReceiptDataEditor extends StatelessWidget {
  final int flex;
  final String title;
  final bool isExpanded;
  final bool selectMode;
  final Widget objectsList;
  final VoidCallback onResized;
  final VoidCallback onAddObject;
  final ThemeController themeController = Get.find();
  final List<SelectModeEditorOption> selectModeOptions;

  ReceiptDataEditor({
    super.key,
    required this.flex,
    required this.title,
    required this.isExpanded,
    required this.objectsList,
    required this.onResized,
    required this.onAddObject,
    required this.selectMode,
    required this.selectModeOptions,
  });

  Widget get topBar => DataEditorTopBar(
        isExpanded: isExpanded,
        onResized: onResized,
        background: themeController.theme.mainColor,
        title: title,
        onAddObject: onAddObject,
        selectModeOptions: selectModeOptions,
        selectMode: selectMode,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              topBar,
              objectsList,
            ],
          ),
        ),
      ),
    );
  }
}
