import 'package:flutter/material.dart';
import 'new_definations.dart';
import 'table_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      ), // Changed app bar title
      body: Container(
        alignment: Alignment.topCenter,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductTable(
              products: productList, 
              heightTable: screenHeight - 205,
              onEditClicked: (int index){},
              onRemoveClicked: (int index){}),
            const SizedBox(height: 16), // Added some spacing at the bottom
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
                    onPressed:
                        () => Navigator.pushNamed(context, '/addProduct'),
                    child: const Text(
                      'Thêm Sản Phẩm',
                      style: TextStyle(color: Color(0xFF006A71)),
                    ),
                  ),
                  // Removed the "Tất Cả Sản Phẩm" button as we are already on that screen
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
