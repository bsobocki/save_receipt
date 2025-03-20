import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/home/shared/enum.dart';

class LoadingAnimation extends StatelessWidget {
  final ReceiptProcessingState processingState;
  final ThemeController themeController = Get.find();

  LoadingAnimation({super.key, required this.processingState});

  get choosingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.dotsTriangle(
              color: themeController.theme.mainColor, size: 100.0),
          Text("Choose Image to process",
              style: TextStyle(color: themeController.theme.mainColor))
        ],
      );

  get readyContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outlined,
              color: themeController.theme.mainColor, size: 100.0),
          Text("Ready!",
              style: TextStyle(color: themeController.theme.mainColor))
        ],
      );

  get processingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
              color: themeController.theme.mainColor, size: 100.0),
          Text('Processing Image...',
              style: TextStyle(color: themeController.theme.mainColor)),
        ],
      );

  get barcodeContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.stretchedDots(
              color: themeController.theme.mainColor, size: 100.0),
          Text('Trying to extract barcode...',
              style: TextStyle(color: themeController.theme.mainColor)),
        ],
      );

  get formattingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.beat(
              color: themeController.theme.mainColor, size: 100.0),
          Text('Document Formatting...',
              style: TextStyle(color: themeController.theme.mainColor)),
        ],
      );

  get fetchingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.newtonCradle(
              color: themeController.theme.mainColor, size: 100.0),
          Text('Document Formatting...',
              style: TextStyle(color: themeController.theme.mainColor)),
        ],
      );

  get content {
    switch (processingState) {
      case ReceiptProcessingState.processing:
        return processingContent;
      case ReceiptProcessingState.imageChoosing:
        return choosingContent;
      case ReceiptProcessingState.ready:
        return readyContent;
      case ReceiptProcessingState.barcodeExtracting:
        return barcodeContent;
      case ReceiptProcessingState.documentFormatting:
        return formattingContent;
      case ReceiptProcessingState.fetchingData:
        return fetchingContent;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: content);
  }
}
