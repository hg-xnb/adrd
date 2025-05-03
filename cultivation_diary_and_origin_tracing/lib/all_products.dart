import 'package:flutter/material.dart';
import 'new_definations.dart';
import 'table_view.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  void _editProduct(int index) async {
    // Navigate to ProductProperties and wait for the result
    final result = await Navigator.pushNamed(
      context,
      '/productProperties',
      arguments: index, // Pass the index
    );

    // Handle the returned updatedProduct
    if (result is Product) {
      setState(() {
        productsList.removeByIndex(index);
        productsList.addProduct(result);
      });
      // Show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sản phẩm đã được cập nhật')),
        );
      }
    }
  }

  void _removeProduct(int index) {
    setState(() {
      productsList.removeByIndex(index);
    });
  }

  void _sortByImportTimeAscending() {
    setState(() {
      productsList.sortByImportTimeAscending();
    });
  }

  void _sortByImportTimeDescending() {
    setState(() {
      productsList.sortByImportTimeDescending();
    });
  }

  void _sortByInfoAscending() {
    setState(() {
      productsList.sortByInfoAscending();
    });
  }

  void _sortByInfoDescending() {
    setState(() {
      productsList.sortByInfoDescending();
    });
  }

  void _sortByNameAscending() {
    setState(() {
      productsList.sortByNameAscending();
    });
  }

  void _sortByNameDescending() {
    setState(() {
      productsList.sortByNameDescending();
    });
  }

  void _sortByCatagoryAscending() {
    setState(() {
      productsList.sortByCategoryAscending();
    });
  }

  void _sortByCatagoryDescending() {
    setState(() {
      productsList.sortByCategoryDescending();
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
              products: productsList,
              heightTable: screenHeight - 225,
              onEditClicked: _editProduct,
              onRemoveClicked: _removeProduct,
              onSortByImportTimeAscending: _sortByImportTimeAscending,
              onSortByImportTimeDescending: _sortByImportTimeDescending,
              onSortByInfoAscending: _sortByInfoAscending,
              onSortByInfoDescending: _sortByInfoDescending,
              onSortByNameAscending: _sortByNameAscending,
              onSortByNameDescending: _sortByNameDescending,
              onSortByCategoryAscending: _sortByCatagoryAscending,
              onSortByCategoryDescending: _sortByCatagoryDescending,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pushNamed(context, '/scanQRCode'),
                    child: const Text(
                      'Quét mã QR',
                      style: TextStyle(color: Color(0xFF006A71)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          '/productsReport',
                          arguments: productsList,
                        ),
                    child: const Text(
                      'Thống kê',
                      style: TextStyle(color: Color(0xFF006A71)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          '/settingsUtilities',
                          arguments: productsList,
                        ),
                    child: const Text(
                      'Khác',
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
