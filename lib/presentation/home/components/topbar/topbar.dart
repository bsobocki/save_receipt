import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/home/components/menu.dart';

import 'search_bar.dart';

class HomepageTopbar extends PreferredSize {
  final String title;
  final VoidCallback onRefreshData;
  final TextEditingController searchTextController;
  final ThemeController themeController = Get.find();

  HomepageTopbar({
    required this.title,
    required this.onRefreshData,
    required this.searchTextController,
    super.key,
  }) : super(
          child: const SizedBox(),
          preferredSize: const Size.fromHeight(138),
        );

  Widget get titleWidget => Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.receipt_long_rounded,
                color: Colors.white.withOpacity(0.6)),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      );

  Widget _buildDecoratedTopBarContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: themeController.theme.gradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: child,
    );
  }

  Widget _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        title: titleWidget,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Menu(onRefreshData: onRefreshData),
          ),
        ],
      );

  Widget _buildSearchBar() => TopBarSearchBar(
        searchTextController: searchTextController,
      );

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: _buildDecoratedTopBarContainer(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }
}
