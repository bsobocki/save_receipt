import 'dart:io';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Image resizeImageWithPadding(Image image) {
  final newHeight = image.height < 32 ? 32 : image.height;
  final newWidth = image.width < 32 ? 32 : image.width;
  return copyResize(image, height: newHeight, width: newWidth);
}

Future<String> saveTemporaryImage(Image tmpImg) async {
  final tmpDir = await getTemporaryDirectory();
  final tempFilePath = '${tmpDir.path}/resized_image.png';
  final tempFile = File(tempFilePath);
  tempFile.writeAsBytesSync(encodePng(tmpImg));
  return tempFilePath;
}

Future<void> deleteTemporaryImage(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    try {
      await file.delete();
      print('Temporary file deleted successfully');
    } catch (e) {
      print('Error deleting temporary file: $e');
    }
  } else {
    print('Temporary file does not exist');
  }
}

Future<String?> pickImage() async {
  final XFile? file =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  return file?.path;
}
