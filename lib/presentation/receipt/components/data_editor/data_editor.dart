import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/components/data_editor_top_bar.dart';
import 'package:save_receipt/presentation/receipt/shared/structures.dart';

enum ReceiptDataContent { products, info }

class ReceiptDataEditor extends StatefulWidget {
  final int flex;
  final String title;
  final bool areProductsEdited;
  final bool selectionMode;
  final Widget infoList;
  final Widget productsList;
  final VoidCallback onAddObject;
  final VoidCallback onInfoTabPressed;
  final VoidCallback onProductsTabPressed;
  final Function(String) onTitleChanged;
  final List<SelectionModeEditorOption> selectionModeOptions;

  const ReceiptDataEditor({
    super.key,
    required this.flex,
    required this.title,
    required this.areProductsEdited,
    required this.selectionMode,
    required this.infoList,
    required this.onAddObject,
    required this.productsList,
    required this.onInfoTabPressed,
    required this.onProductsTabPressed,
    required this.onTitleChanged,
    required this.selectionModeOptions,
  });

  @override
  State<ReceiptDataEditor> createState() => _ReceiptDataEditorState();
}

class _ReceiptDataEditorState extends State<ReceiptDataEditor> {
  final ThemeController themeController = Get.find();
  late final TextEditingController titleEditingController;
  bool showProducts = true;

  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController(text: widget.title);
  }

  get decoration => BoxDecoration(
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
      );

  Widget _buildTopBar() => DataEditorTopBar(
        onResized: widget.onProductsTabPressed,
        background: themeController.theme.mainColor,
        onAddObject: widget.onAddObject,
        selectionModeOptions: widget.selectionModeOptions,
        selectionMode: widget.selectionMode,
        titleEditingController: titleEditingController,
        onTitleChanged: widget.onTitleChanged,
      );

  Widget _buildContentTab({
    required ReceiptDataContent content,
    required VoidCallback onPressed,
  }) {
    bool isProductTab = content == ReceiptDataContent.products;
    bool isSelected =
        (showProducts && isProductTab) || (!showProducts && !isProductTab);

    Color background = Colors.white;
    Color textColor = themeController.theme.mainColor;
    if (isSelected) {
      background = themeController.theme.mainColor;
      textColor = Colors.white;
    }

    return RotatedBox(
      quarterTurns: 3,
      child: GestureDetector(
        onTap: () => setState(() {
          showProducts = isProductTab;
          onPressed();
        }),
        child: Container(
          decoration: BoxDecoration(
            color: background,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: 90,
          height: 30,
          child: Center(
            child: Text(
              isProductTab ? 'Products' : 'Info',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationVerticalBar() => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0)),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildContentTab(
                        content: ReceiptDataContent.products,
                        onPressed: widget.onProductsTabPressed),
                    _buildContentTab(
                        content: ReceiptDataContent.info,
                        onPressed: widget.onInfoTabPressed),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDataEditorList() => Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              //bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: showProducts ? widget.productsList : widget.infoList,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: decoration,
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Row(
                  children: [
                    _buildNavigationVerticalBar(),
                    _buildDataEditorList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
