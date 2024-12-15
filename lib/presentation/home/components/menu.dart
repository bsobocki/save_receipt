import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.onRefreshData});

  final VoidCallback onRefreshData;

  IconData getIconByOption(String text) {
    switch (text) {
      case 'delete database':
        return Icons.playlist_remove_rounded;
      case 'refresh':
        return Icons.refresh;
      case 'print database':
        return Icons.text_snippet_sharp;
      default:
        return Icons.keyboard_option_key;
    }
  }

  PopupMenuItem<String> getPopupMenuItem(String text) {
    return PopupMenuItem<String>(
        value: text,
        child: Row(
          children: [
            Icon(getIconByOption(text), color: Colors.white),
            const SizedBox(width: 8),
            Text(text),
          ],
        ));
  }

  Future<void> deleteDatabaseDialogBuilder(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Database Confirmation'),
          backgroundColor: mainTheme.mainColor,
          shadowColor: Colors.black,
          content: const Text(
            'Do you want to delete database?\n',
            style: TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text('Delete'),
              onPressed: () async {
                await ReceiptDatabaseRepository.get.deleteDb();
                onRefreshData();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: mainTheme.mainColor,
      onSelected: (String value) async {
        switch (value) {
          case 'delete database':
            await deleteDatabaseDialogBuilder(context);
            break;
          case 'refresh':
            onRefreshData();
            break;
          case 'print database':
            await ReceiptDatabaseRepository.get.printDatabase();
            break;
        }
      },
      itemBuilder: (context) => ['delete database', 'refresh', 'print database']
          .map((text) => getPopupMenuItem(text))
          .toList(),
      child: const Icon(Icons.menu),
    );
  }
}
