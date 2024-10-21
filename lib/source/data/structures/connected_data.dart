
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ConnectedTextLines {
  final TextLine start;
  final TextLine? connectedLine;

  ConnectedTextLines({required this.start, required this.connectedLine});

  @override
  String toString() =>
      '{${start.text} => ${connectedLine?.text ?? ''}}\n';
}