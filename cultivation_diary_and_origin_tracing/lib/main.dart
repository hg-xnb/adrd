import 'package:flutter/material.dart';
import 'settings_utilities_screen.dart';
import 'product_properties.dart';
import 'products_report.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'new_definations.dart';
import 'all_products.dart';

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
          final ProductsList productsList =
              ModalRoute.of(context)!.settings.arguments as ProductsList;
          return ProductsReportScreen(products: productsList);
        },
        '/scanQRCode': (_) => const ScanScreen(),
        '/productProperties': (context) {
          final int index = ModalRoute.of(context)!.settings.arguments as int;
          return ProductProperties(index: index);
        },
        '/settingsUtilities': (context) {
          final ProductsList productsList =
              ModalRoute.of(context)!.settings.arguments as ProductsList;
          return SettingsUtilitiesScreen(productsList: productsList);
        },
        '/allProducts': (context) => const AllProducts(),
      },
    );
  }
}
