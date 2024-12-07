import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/schemes/main_sheme.dart';
import 'package:save_receipt/presentation/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: mainColorScheme, // ColorScheme.highContrastDark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Receipt Save'),
    );
  }
}
