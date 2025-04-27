import 'package:flutter/material.dart';
import 'product_properties.dart';
import 'products_report.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'new_definations.dart';

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
        '/productsReport': (context) {
          final ProductList productList =
              ModalRoute.of(context)!.settings.arguments as ProductList;
          return ProductsReportScreen(products: productList,);
        },
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