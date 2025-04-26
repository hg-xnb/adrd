import 'package:flutter/material.dart';
import 'new_definations.dart';
import 'table_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _editProduct(int index) {
  }

  void _removeProduct(int index) {
    setState(() {
    });
  }

  void _sortByImportTimeAscending() {
    setState(() {
    });
  }

  void _sortByImportTimeDescending() {
    setState(() {
    });
  }

  void _sortByInfoAscending() {
    setState(() {
    });
  }

  void _sortByInfoDescending() {
    setState(() {
    });
  }

  void _sortByNameAscending() {
    setState(() {
    });
  }

  void _sortByNameDescending() {
    setState(() {
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tất Cả Sản Phẩm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF006A71),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductTable(
              products: productList,
              heightTable: screenHeight - 205,
              onEditClicked: _editProduct,
              onRemoveClicked: _removeProduct,
              onSortByImportTimeAscending: _sortByImportTimeAscending,
              onSortByImportTimeDescending: _sortByImportTimeDescending,
              onSortByInfoAscending: _sortByInfoAscending,
              onSortByInfoDescending: _sortByInfoDescending,
              onSortByNameAscending: _sortByNameAscending,
              onSortByNameDescending: _sortByNameDescending,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/scanQRCode'),
                    child: const Text(
                      'Quét mã QR',
                      style: TextStyle(color: Color(0xFF006A71)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/addProduct'),
                    child: const Text(
                      'Thêm Sản Phẩm',
                      style: TextStyle(color: Color(0xFF006A71)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}