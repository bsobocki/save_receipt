import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor_top_bar.dart';

enum ReceiptDataContent { products, info }

class ReceiptDataEditor extends StatefulWidget {
  final int flex;
  final String title;
  final bool areProductsEdited;
  final bool selectMode;
  final Widget infoList;
  final Widget productsList;
  final VoidCallback onAddObject;
  final VoidCallback onInfoTabPressed;
  final VoidCallback onProductsTabPressed;
  final List<SelectModeEditorOption> selectModeOptions;

  const ReceiptDataEditor({
    super.key,
    required this.flex,
    required this.title,
    required this.areProductsEdited,
    required this.selectMode,
    required this.infoList,
    required this.onAddObject,
    required this.productsList,
    required this.onInfoTabPressed,
    required this.onProductsTabPressed,
    required this.selectModeOptions,
  });

  @override
  State<ReceiptDataEditor> createState() => _ReceiptDataEditorState();
}

class _ReceiptDataEditorState extends State<ReceiptDataEditor> {
  final ThemeController themeController = Get.find();
  bool showProducts = true;

  Widget get topBar => DataEditorTopBar(
        onResized: widget.onProductsTabPressed,
        background: themeController.theme.mainColor,
        onAddObject: widget.onAddObject,
        selectModeOptions: widget.selectModeOptions,
        selectMode: widget.selectMode,
      );

  Widget contentTab(ReceiptDataContent content) {
    bool productTab = content == ReceiptDataContent.products;
    Color background = Colors.white;
    Color textColor = themeController.theme.mainColor;
    bool currentContentTab =
        (showProducts && productTab) || (!showProducts && !productTab);
    VoidCallback onPressed = content == ReceiptDataContent.products
        ? widget.onProductsTabPressed
        : widget.onInfoTabPressed;

    if (currentContentTab) {
      background = themeController.theme.mainColor;
      textColor = Colors.white;
    }

    return RotatedBox(
      quarterTurns: 3,
      child: GestureDetector(
        onTap: () => setState(() {
          showProducts = productTab;
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
              productTab ? 'Products' : 'Info',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get navigationVerticalBar => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0)),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    contentTab(ReceiptDataContent.products),
                    contentTab(ReceiptDataContent.info),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
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
              Expanded(
                child: Row(
                  children: [
                    navigationVerticalBar,
                    Expanded(
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
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: showProducts
                            ? widget.productsList
                            : widget.infoList,
                      ),
                    ),
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
