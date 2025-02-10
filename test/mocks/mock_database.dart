// test/mocks/mock_database.dart
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';

// Only use the annotation, don't create the class manually
@GenerateMocks([Database])
void main() {}