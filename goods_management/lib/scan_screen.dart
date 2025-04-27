import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'product_properties.dart';
import 'new_definations.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isDialogShown = false;

  void _handleScan(BuildContext context, String scannedCode) {
    if (_isDialogShown) return;
    _isDialogShown = true;

    final existingProduct = productList.findProductByID(scannedCode);

    if (existingProduct != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sản phẩm đã tồn tại'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mã sản phẩm: ${existingProduct.productID}'),
              Text('Tên: ${existingProduct.name ?? "Không có"}'),
              Text('Xuất xứ: ${existingProduct.origin ?? "Không có"}'),
              Text('Thông tin: ${existingProduct.info ?? "Không có"}'),
              Text('Giá: ${existingProduct.price?.toString() ?? "Không có"}'),
              Text('Danh mục: ${existingProduct.category ?? "Không có"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _isDialogShown = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductProperties(
                      index: productList.allProducts.indexOf(existingProduct),
                    ),
                  ),
                );
              },
              child: const Text('Mở'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _isDialogShown = false;
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sản phẩm không tồn tại'),
          content: Text('Bạn có muốn thêm sản phẩm mới với mã "$scannedCode"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final newProduct = Product(productID: scannedCode);
                productList.addProduct(newProduct);
                _isDialogShown = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductProperties(
                      index: productList.allProducts.indexOf(newProduct),
                    ),
                  ),
                );
              },
              child: const Text('Thêm mới'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _isDialogShown = false;
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét QRCODE')),
      body: Stack(
        children: [
          // Camera hiển thị dưới
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              if (capture.barcodes.isEmpty) return;
              final barcode = capture.barcodes.first;
              final String? code = barcode.rawValue;
              if (code != null) {
                _handleScan(context, code);
              }
            },
          ),
          // Khung scan ở giữa
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Làm mờ xung quanh
          _buildOverlay(),
        ],
      ),
    );
  }

  // Tạo lớp overlay mờ ngoài vùng scan
  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double scanBoxSize = 250;
        final double left = (width - scanBoxSize) / 2;
        final double top = (height - scanBoxSize) / 2;

        return Stack(
          children: [
            // Top
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: top,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            // Bottom
            Positioned(
              left: 0,
              right: 0,
              top: top + scanBoxSize,
              bottom: 0,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            // Left
            Positioned(
              left: 0,
              top: top,
              width: left,
              height: scanBoxSize,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            // Right
            Positioned(
              right: 0,
              top: top,
              width: left,
              height: scanBoxSize,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ],
        );
      },
    );
  }
}
