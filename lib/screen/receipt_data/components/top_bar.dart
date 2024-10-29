import 'dart:io';

import 'package:flutter/material.dart';

class ReceiptPageTopBar extends StatelessWidget {
  const ReceiptPageTopBar({super.key, this.receiptImgPath, required this.onImageIconPress});
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;

  get receiptIcon {
    if (receiptImgPath != null) {
      return Image.file(File(receiptImgPath!), fit: BoxFit.cover);
    }
    return Image.asset("assets/no_image.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.chevron_left_outlined),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                onPressed: () => print('pressed save'),
                icon: const Icon(Icons.save),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: IconButton(
            onPressed: onImageIconPress,
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: receiptIcon,
            ),
          ),
        ),
      ],
    );
    ;
  }
}
