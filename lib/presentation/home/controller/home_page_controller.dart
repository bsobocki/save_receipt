import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/home/components/home_page_navigation_bar.dart';
import 'package:save_receipt/presentation/home/components/loading_animation.dart';
import 'package:save_receipt/presentation/receipt/receipt_data_page.dart';
import 'package:save_receipt/services/data_processing/connect_data.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/services/data_processing/parse_data.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';
import 'package:save_receipt/services/document/scan/google_read_text_from_image.dart';

class HomePageController extends GetxController {
  final documentData = <ReceiptDocumentData>[].obs;
  final processingState = ReceiptProcessingState.noAction.obs;
  final searchQuery = ''.obs;
  final selectedPage = NavigationPages.receipts.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void setProcessingState(ReceiptProcessingState newState) =>
      processingState.value = newState;

  Widget buildImgWidget(String imgPath) {
    if (imgPath.isEmpty) {
      return Image.asset('assets/no_image.jpg');
    } else {
      return Image.file(File(imgPath));
    }
  }

  Future<void> fetchData() async {
    setProcessingState(ReceiptProcessingState.fetchingData);
    documentData.value =
        await ReceiptDatabaseRepository.get.getAllDocumentDatas();
    resetProcessingState();
  }

  bool _productMatchesQuery(ProductData product) =>
      product.name.toLowerCase().contains(searchQuery.value.toLowerCase());

  List<ReceiptDocumentData> get filteredData {
    if (searchQuery.value.isNotEmpty) {
      return documentData
          .where((data) => data.products.any(_productMatchesQuery))
          .toList();
    }
    return documentData;
  }

  List<ProductData> get filteredProducts {
    List<ProductData> filteredData =
        documentData.expand((data) => data.products).toList();
    if (searchQuery.value.isNotEmpty) {
      filteredData = filteredData.where(_productMatchesQuery).toList();
    }
    return filteredData;
  }

  Future<void> deleteReceipt(int id) async {
    ReceiptDatabaseRepository.get.deleteReceipt(id);
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

  Future<void> processDataFromReceipt(
      {required Future<String?> Function() getDocumentPathCallback}) async {
    setProcessingState(ReceiptProcessingState.imageChoosing);
    String? filePath = await getDocumentPathCallback();
    if (filePath != null) {
      setProcessingState(ReceiptProcessingState.processing);
      ProcessedDataModel? processedDataModel = await processImg(filePath);
      if (processedDataModel != null) {
        String? time = processedDataModel.allValuesModel.time.firstOrNull;
        String title = 'Receipt';
        if (time != null) {
          title += ' from $time';
        }
        await Future.delayed(const Duration(milliseconds: 200));
        await openReceiptPage(
          receiptModel: ReceiptModel(
            title: title,
            imgPath: filePath,
            objects: processedDataModel.receiptObjectModels,
          ),
          allValuesModel: processedDataModel.allValuesModel,
        );
      } else {
        setProcessingState(ReceiptProcessingState.error);
      }
    }
    setProcessingState(ReceiptProcessingState.noAction);
  }

  Future<void> openReceiptPage({
    ReceiptModel? receiptModel,
    AllValuesModel? allValuesModel,
  }) async {
    if (receiptModel != null) {
      ReceiptBarcodeData? barcodeData;

      if (receiptModel.imgPath != null) {
        GoogleBarcodeScanner scanner =
            GoogleBarcodeScanner(receiptModel.imgPath!);
        processingState.value = ReceiptProcessingState.barcodeExtracting;
        await scanner.scanImage();
        barcodeData = scanner.data;
      }

      processingState.value = ReceiptProcessingState.ready;
      await Future.delayed(const Duration(milliseconds: 500));
      Get.to(
        () => ReceiptDataPage(
          initialReceipt: receiptModel,
          allValuesModel: allValuesModel,
          barcodeData: barcodeData,
        ),
        transition: Transition.rightToLeft,
      )?.then(
        (_) {
          setProcessingState(ReceiptProcessingState.noAction);
          fetchData();
        },
      );
    }
  }

  void resetProcessingState() =>
      setProcessingState(ReceiptProcessingState.noAction);

  void resetSearchQuery() => searchQuery.value = '';
}
