import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/home/shared/enum.dart';

class HomePageNavigationBar extends StatefulWidget {
  final Function(NavigationPages) onPageSelect;
  final NavigationPages selectedPage;

  const HomePageNavigationBar(
      {super.key, required this.onPageSelect, required this.selectedPage});

  @override
  State<HomePageNavigationBar> createState() => _HomePageNavigationBarState();
}

class _HomePageNavigationBarState extends State<HomePageNavigationBar> {
  final themeController = Get.find<ThemeController>();
  int currIndex = 0;
  final Map<NavigationPages, IconData> itemsDatas = {
    NavigationPages.receipts: Icons.receipt_long,
    NavigationPages.products: Icons.inventory
  };

  void onTap(int index) {
    currIndex = index;
    widget.onPageSelect(NavigationPages.values[currIndex]);
  }

  int indexOf(NavigationPages page) => NavigationPages.values.indexOf(page);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currIndex,
      onTap: onTap,
      items: itemsDatas.entries
          .map(
            (entry) => BottomNavigationBarItem(
                label: entry.key.label, icon: Icon(entry.value)),
          )
          .toList(),
      type: BottomNavigationBarType.shifting,
      selectedItemColor: themeController.theme.mainColor,
      unselectedItemColor: Colors.grey,
    );
  }
}
