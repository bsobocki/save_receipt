import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor_top_bar.dart';

class ReceiptDataEditor extends StatelessWidget {
  final int flex;
  final String title;
  final bool areProductsEdited;
  final bool selectMode;
  final Widget infoList;
  final Widget productsList;
  final VoidCallback onResized;
  final VoidCallback onAddObject;
  final ThemeController themeController = Get.find();
  final List<SelectModeEditorOption> selectModeOptions;

  ReceiptDataEditor({
    super.key,
    required this.flex,
    required this.title,
    required this.areProductsEdited,
    required this.infoList,
    required this.productsList,
    required this.onResized,
    required this.onAddObject,
    required this.selectMode,
    required this.selectModeOptions,
  });

  Widget get topBar => DataEditorTopBar(
        isExpanded: areProductsEdited,
        onResized: onResized,
        background: themeController.theme.mainColor,
        onAddObject: onAddObject,
        selectModeOptions: selectModeOptions,
        selectMode: selectMode,
      );

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
            RotatedBox(
              quarterTurns: 3,
              child: GestureDetector(
                onTap: () {
                  print("Products pressed!");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 90,
                  height: 30,
                  child: Center(
                    child: Text(
                      'Products',
                      style: TextStyle(
                        color: themeController.theme.mainColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: GestureDetector(
                onTap: () {
                  print("Info pressed!");
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: themeController.theme.mainColor.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 90,
                    height: 30,
                    child: const Center(child: Text('Info'))),
              ),
            ),
          ],
        ),
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
                        child: productsList,
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
