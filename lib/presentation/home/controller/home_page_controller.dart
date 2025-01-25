import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_receipt/services/data_processing/connect_data.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/services/data_processing/parse_data.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/services/document/scan/google_read_text_from_image.dart';
import 'package:save_receipt/services/document/scan/google_scan.dart';

class HomePageController {
  String imgPath = "";
  final ImagePicker picker = ImagePicker();
  late Future<List<ReceiptDocumentData>> _documentData;

  get documentData => _documentData;

  Widget getImg() {
    if (imgPath.isEmpty) {
      return Image.asset('assets/no_image.jpg');
    } else {
      return Image.file(File(imgPath));
    }
  }

  void fetchData() {
    _documentData = ReceiptDatabaseRepository.get.getAllDocumentDatas();
  }

  Future<void> deleteReceipt(int id) async {
    ReceiptDatabaseRepository.get.deleteReceipt(id);
  }

  Future<String?> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }

  Future<String?> googleScanAndExtractRecipe() async {
    return await scanRecipe();
  }

  Future<ProcessedDataModel?> processImg(String? filePath) async {
    if (filePath != null) {
      List<TextLine> textLines = await processImage(filePath);
      List<ConnectedTextLines> connectedLines =
          getConnectedTextLines(textLines, RectArea.center);
      DataParser parser = DataParser.parseData(connectedLines);
      return parser.processedDataModel;
    }
    return null;
  }
}
