import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/core/utils/enums.dart';

enum NavigationPages { receipts, products }

extension NavigationPagesExtension on NavigationPages {
  String get label => enumLabel(this);
}

class HomePageNavigationBar extends StatefulWidget {
  final Function(NavigationPages) onPageSelect;

  const HomePageNavigationBar({super.key, required this.onPageSelect});

  @override
  State<HomePageNavigationBar> createState() => _HomePageNavigationBarState();
}

class _HomePageNavigationBarState extends State<HomePageNavigationBar> {
  int _currentIndex = 0;

  final Map<NavigationPages, IconData> itemsDatas = {
    NavigationPages.receipts: Icons.receipt_long,
    NavigationPages.products: Icons.inventory
  };

  void onTap(int index) => setState(() {
        _currentIndex = index;
        widget.onPageSelect(NavigationPages.values[index]);
      });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onTap,
      items: itemsDatas.entries
          .map(
            (entry) => BottomNavigationBarItem(
                label: entry.key.label, icon: Icon(entry.value)),
          )
          .toList(),
      type: BottomNavigationBarType.shifting,
      selectedItemColor: mainTheme.mainColor,
      unselectedItemColor: Colors.grey,
    );
  }
}
