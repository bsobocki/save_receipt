import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';

class Menu extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final VoidCallback onRefreshData;

  Menu({super.key, required this.onRefreshData});

  IconData getIconByOption(String text) {
    switch (text) {
      case 'delete database':
        return Icons.playlist_remove_rounded;
      case 'refresh':
        return Icons.refresh;
      case 'print database':
        return Icons.text_snippet_sharp;
      case 'change theme':
        return Icons.color_lens;
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
          backgroundColor: themeController.theme.mainColor,
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

  Future<void> changeThemeDialogBuilder(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose theme you want to change'),
          backgroundColor: themeController.theme.mainColor,
          shadowColor: Colors.black,
          content: SizedBox(
            width: 300,
            height: 300,
            child: ListView.builder(
              itemCount: themeController.availableColors.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: themeController.availableColors[index],
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(1, 2))
                      ]),
                  child: GestureDetector(onTap: () {
                    themeController.changeMainColor(
                        themeController.availableColors[index]);
                    onRefreshData();
                    Navigator.of(context).pop();
                  }),
                ),
              ),
            ),
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: themeController.theme.mainColor,
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
          case 'change theme':
            await changeThemeDialogBuilder(context);
            break;
        }
      },
      itemBuilder: (context) => [
        'delete database',
        'refresh',
        'print database',
        'change theme'
      ].map((text) => getPopupMenuItem(text)).toList(),
      child: const Icon(Icons.menu),
    );
  }
}
