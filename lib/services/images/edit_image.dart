import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

Uint8List? changePhotoToDocumentAsBytes(String path) {
  File imgFile = File(path);
  final bytes = imgFile.readAsBytesSync();
  Image? photo = decodeImage(bytes);

  if (photo != null) {
    // photo = grayscale(photo);
    // photo = contrast(photo, contrast: 150);
    // // 5. Sharpen image using a 3×3 convolution filter
    // //    The commonly used sharpening filter is:
    // //    [ 0, -1,  0,
    // //     -1,  5, -1,
    // //      0, -1,  0 ]
    // //    "div: 1" => no division of the convolution sum.
    // //    "offset: 0" => no brightness shift.
    // //    "edge: EdgeMode.clamp" => clamp pixels so they don't go out of range.
    // photo = convolution(
    //   photo,
    //   filter: [
    //     0,
    //     -1,
    //     0,
    //     -1,
    //     6,
    //     -1,
    //     0,
    //     -1,
    //     0,
    //   ],
    //   div: 1,
    //   offset: 0,
    // );
    return Uint8List.fromList(encodePng(adjustDocument(photo)));
  }
  return null;
}

Uint8List? adjustDocumentBytes(Uint8List? bytes) {
  if (bytes == null) return null;
  Image? photo = decodeImage(bytes);
  if (photo == null) return null;
  return Uint8List.fromList(encodePng(adjustDocument(photo)));
}

Image adjustDocument(Image photo) {
  return convolution(
    contrast(
      grayscale(photo),
      contrast: 150,
    ),
    filter: [
      0,
      -1,
      0,
      -1,
      6,
      -1,
      0,
      -1,
      0,
    ],
    div: 1,
    offset: 0,
  );
}
