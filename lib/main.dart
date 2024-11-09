import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_receipt/color/gradient.dart';
import 'package:save_receipt/color/scheme/main_sheme.dart';
import 'package:save_receipt/screen/receipt_data/receipt_data_page.dart';
import 'package:save_receipt/source/data/connect_data.dart';
import 'package:save_receipt/source/data/parse_data.dart';
import 'package:save_receipt/source/data/structures/connected_data.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';
import 'package:save_receipt/source/document_operations/scan/google_read_text_from_image.dart';
import 'package:save_receipt/source/document_operations/scan/google_scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: mainColorScheme,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Receipt Save'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _expandableFabKey = GlobalKey<ExpandableFabState>();
  final ImagePicker picker = ImagePicker();
  String imageScannerText = "Please select an image to scan.";
  String imageProcessingText = "Please select an image to process.";
  String imgPath = "";

  Widget getImg() {
    if (imgPath.isEmpty) {
      return Image.asset('assets/no_image.jpg');
    } else {
      return Image.file(File(imgPath));
    }
  }

  Future<Receipt?> _readImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      String filePath = file.path;
      var textLines = await processImage(filePath);
      List<ConnectedTextLines> connectedLines =
          getConnectedTextLines(textLines);
      List<ReceiptObject> parsedObjects = parseData(connectedLines);
      return Receipt(
        imgPath: filePath,
        objects: parsedObjects,
      );
    }
    return null;
  }

  Future<Receipt?> _googleScanAndExtractRecipe() async {
    try {
      String tmpPath = await scanRecipe();
      List<TextLine> textLines = await processImage(tmpPath);
      List<ConnectedTextLines> connectedLines =
          getConnectedTextLines(textLines);
      List<ReceiptObject> parsedObjects = parseData(connectedLines);
      return Receipt(
        imgPath: tmpPath,
        objects: parsedObjects,
      );
    } catch (e) {
      print('Cannot receive receipt object: $e');
    }
    return null;
  }

  void toggleFloatingActionButton() {
    if (_expandableFabKey.currentState != null) {
      _expandableFabKey.currentState!.toggle();
    }
  }

  void openReceiptPage(Receipt? receipt) {
    if (receipt != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptDataPage(
            initialReceipt: receipt,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: mainGradient,
          ),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              imageProcessingText,
              style: const TextStyle(color: Colors.blueGrey),
            ),
            Text(
              imageScannerText,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.adb_outlined), label: 'label'),
          BottomNavigationBarItem(
              icon: Icon(Icons.adobe_rounded), label: 'label'),
        ],
        unselectedItemColor: Colors.grey[400],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _expandableFabKey,
        // type: ExpandableFabType.fan,
        pos: ExpandableFabPos.center,
        distance: 90,
        fanAngle: 130,
        overlayStyle: const ExpandableFabOverlayStyle(
          blur: 1.0,
          color: Color.fromARGB(100, 100, 100, 100),
        ),
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
          Column(
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  toggleFloatingActionButton();
                  openReceiptPage(await _googleScanAndExtractRecipe());
                },
                child: Image.asset(
                  'assets/googleScannerIcon.png',
                  height: 24,
                  width: 24,
                ),
              ),
              const Text("scan"),
            ],
          ),
          Column(
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  toggleFloatingActionButton();
                  openReceiptPage(await _readImage());
                },
                child: const Icon(Icons.drive_folder_upload),
              ),
              const Text("import"),
            ],
          ),
        ],
      ),
    );
  }
}
