import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ReceiptDataPage extends StatefulWidget {
  const ReceiptDataPage({super.key});
  final String title = 'Fill Receipt Data';

  @override
  State<ReceiptDataPage> createState() => _ReceiptDataPageState();
}

class _ReceiptDataPageState extends State<ReceiptDataPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => print('saved'), icon: const Icon(Icons.save))
        ],
      ),
      body: const Center(
        child: Column(
          children: [],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.center,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.receipt_sharp),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.regular,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
          foregroundColor: Theme.of(context).colorScheme.primaryFixed,
          shape: const CircleBorder(),
        ),
        children: [
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.drive_folder_upload),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
