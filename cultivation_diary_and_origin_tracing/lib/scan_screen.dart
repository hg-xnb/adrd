import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'new_definations.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isDialogShown = false;
  Product? _currentProduct; // Track the current scanned product

  Future<void> _handleNewProduct(String scannedCode) async {
    Navigator.pop(context); // Close the dialog immediately

    // Wait a tiny bit to ensure Navigator.pop is finished
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    final newProduct = Product(productID: scannedCode);
    productsList.addProduct(newProduct);
    _isDialogShown = false;

    // PushNamed and pass arguments
    final result = await Navigator.pushNamed(
      context,
      '/productProperties',
      arguments: productsList.allProducts.indexOf(newProduct),
    );
    productsList.removeByIndex(productsList.allProducts.indexOf(newProduct));

    if (!mounted) return;

    if (result is Product) {
      setState(() {
        productsList.addProduct(result);
        _currentProduct = result; // Update lower panel
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đã được cập nhật')),
      );
    } else {
      setState(() {
        _currentProduct = newProduct;
      });
    }
  }

  void _handleScan(BuildContext context, String scannedCode) {
    if (_isDialogShown) return;
    _isDialogShown = true;

    final existingProduct = productsList.findProductByID(scannedCode);

    if (existingProduct != null) {
      setState(() {
        _currentProduct = existingProduct;
      });
      _isDialogShown = false; // No need to show popup if already found
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Sản phẩm không tồn tại'),
              content: Text('Tạo sản phẩm mới với mã "$scannedCode"?'),
              actions: [
                TextButton(
                  onPressed: () {
                    _handleNewProduct(scannedCode);
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
      appBar: AppBar(
        title: const Text(
          'Quét QRCODE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF006A71),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
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
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                _buildOverlay(),
              ],
            ),
          ),
          Expanded(flex: 1, child: _buildProductInfoPanel()),
        ],
      ),
    );
  }

  // Overlay scan zone
  Widget _buildOverlay() {
    // final double screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double scanBoxSize = 250;
        final double left = (width - scanBoxSize) / 2;
        final double top = (height - scanBoxSize) / 2;

        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: top,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: top + scanBoxSize,
              bottom: 0,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            Positioned(
              left: 0,
              top: top,
              width: left,
              height: scanBoxSize,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
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

  Widget _buildProductInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade200,
      width: double.infinity,
      child:
          _currentProduct == null
              ? const Center(child: Text('Chưa có sản phẩm nào'))
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField('Mã sản phẩm', _currentProduct?.productID),
                    const SizedBox(height: 8),
                    _buildField('Tên', _currentProduct?.name),
                    const SizedBox(height: 8),
                    _buildField('Xuất xứ', _currentProduct?.origin),
                    const SizedBox(height: 8),
                    _buildField('Thông tin', _currentProduct?.info),
                    const SizedBox(height: 8),
                    _buildField('Giá', _currentProduct?.price?.toString()),
                    const SizedBox(height: 8),
                    _buildField('Danh mục', _currentProduct?.category),
                    const SizedBox(height: 8),
                    _buildField(
                      'Thời gian nhập',
                      _currentProduct?.importTime?.toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildField(
                      'Thời gian xuất',
                      _currentProduct?.exportTime?.toString(),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
