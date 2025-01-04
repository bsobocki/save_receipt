import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/home/components/menu.dart';

class HomepageTopbar extends PreferredSize {
  final String title;
  final VoidCallback onRefreshData;
  final Function(String) onSearchTextChanged;
  final ThemeController themeController = Get.find();

  HomepageTopbar({
    required this.onSearchTextChanged,
    required this.onRefreshData,
    required this.title,
    super.key,
  }) : super(
          child: const SizedBox(),
          preferredSize: const Size.fromHeight(138),
        );

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: themeController.theme.gradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(title),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Menu(onRefreshData: onRefreshData),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(30),
                    right: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 16.0, right: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search Products',
                          ),
                          onChanged: onSearchTextChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
