import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:save_receipt/services/images/edit_image.dart';

class ReceiptImageViewer extends StatefulWidget {
  final String imagePath;
  final VoidCallback onExit;
  final bool documentFormat;

  const ReceiptImageViewer({
    super.key,
    required this.imagePath,
    required this.onExit,
    required this.documentFormat,
  });

  @override
  State<ReceiptImageViewer> createState() => _ReceiptImageViewerState();
}

class _ReceiptImageViewerState extends State<ReceiptImageViewer> {
  final TransformationController _controller = TransformationController();
  late TapDownDetails _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_controller.value != Matrix4.identity()) {
      _controller.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // Zoom to 2x on double tap
      _controller.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }

  Widget get imageViewer {
    Uint8List? bytes;
    if (widget.documentFormat) bytes = changePhotoToDocumentAsBytes(widget.imagePath);
    return Stack(
      children: [
        InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          transformationController: _controller,
          child: GestureDetector(
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: bytes != null
                ? Image.memory(
                    bytes,
                    //File(widget.imagePath),
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: widget.onExit,
            icon: const Icon(
              Icons.cancel,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: widget.onExit,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: double.infinity,
                  child: imageViewer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
