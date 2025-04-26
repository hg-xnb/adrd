import 'package:flutter/material.dart';
import 'product_properties.dart';
import 'add_new_product.dart';
import 'home_screen.dart';
import 'scan_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goods Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/addProduct': (_) => AddProductScreen(),
        '/scanQRCode': (_) => const ScanScreen(),
        '/productProperties': (context) {
          final int index =
              ModalRoute.of(context)!.settings.arguments as int;
          return ProductProperties(index: index);
        },
      },
    );
  }
}