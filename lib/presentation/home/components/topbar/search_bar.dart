import 'package:flutter/material.dart';

class TopBarSearchBar extends StatelessWidget {
  final TextEditingController searchTextController;
  const TopBarSearchBar({super.key, required this.searchTextController});

  Widget _buildDecoratedContainer({required Widget child}) {
    return Container(
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
          top: 8.0,
          bottom: 8.0,
          left: 16.0,
          right: 16,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildDecoratedContainer(
        child: Row(
          children: [
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: searchTextController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Search Products',
                ),
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
    );
  }
}
