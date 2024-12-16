import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/home/home_page.dart';

class LoadingAnimation extends StatelessWidget {
  final ReceiptProcessingState processingState;
  const LoadingAnimation({super.key, required this.processingState});

  get choosingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.dotsTriangle(
              color: mainTheme.mainColor, size: 100.0),
          Text("Choose Image to process",
              style: TextStyle(color: mainTheme.mainColor))
        ],
      );

  get readyContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outlined,
              color: mainTheme.mainColor, size: 100.0),
          Text("Ready!", style: TextStyle(color: mainTheme.mainColor))
        ],
      );

  get processingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
              color: mainTheme.mainColor, size: 100.0),
          Text('Processing Image...',
              style: TextStyle(color: mainTheme.mainColor)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    switch (processingState) {
      case ReceiptProcessingState.processing:
        return processingContent;
      case ReceiptProcessingState.imageChoosing:
        return choosingContent;
      case ReceiptProcessingState.ready:
        return readyContent;
      default:
        return Container();
    }
  }
}
