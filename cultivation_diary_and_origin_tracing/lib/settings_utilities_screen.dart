import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'new_definations.dart';

class SettingsUtilitiesScreen extends StatelessWidget {
  final ProductsList productsList;

  const SettingsUtilitiesScreen({super.key, required this.productsList});

  // Generate file name with format goods_<current datetime>
  String _generateFileName() {
    final now = DateTime.now();
    final formattedDate = now
        .toIso8601String()
        .replaceAll(RegExp(r'[:T.]'), '')
        .substring(0, 14);
    return 'goods_$formattedDate.json';
  }

  // Check if context is still mounted
  bool _isContextValid(BuildContext context) => context.mounted;

  // Import products from JSON file
  Future<void> _importFromJson(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result?.files.single.path == null) {
        if (_isContextValid(context)) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Không chọn file JSON')));
        }
        return;
      }

      final file = File(result!.files.single.path!);
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);

      // Xóa hết sản phẩm cũ
      final productIds =
          productsList.allProducts.map((p) => p.productID).toList();
      for (final id in productIds) {
        if (id != null) productsList.deleteProduct(id);
      }

      // Thêm sản phẩm mới
      int addedCount = 0;
      for (final item in jsonData) {
        try {
          productsList.addProduct(Product.fromMap(item as Map<String, dynamic>));
          addedCount++;
        } catch (e) {
          if (e is ArgumentError && e.message.contains('already exists')) {
            continue;
          }
          rethrow;
        }
      }

      if (_isContextValid(context)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã nhập $addedCount sản phẩm từ JSON')),
        );
      }
    } catch (e) {
      if (_isContextValid(context)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi nhập JSON: $e')));
      }
    }
  }

  // Import products from QR Code
  Future<void> _importFromQrCode(BuildContext context) async {
    try {
      final scannerController = MobileScannerController();

      final String? qrText = await showDialog<String>(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Quét QR Code')),
            body: MobileScanner(
              controller: scannerController,
              onDetect: (capture) {
                for (final barcode in capture.barcodes) {
                  final rawValue = barcode.rawValue;
                  if (rawValue != null) {
                    scannerController.stop();
                    Navigator.of(context).pop(rawValue);
                    break;
                  }
                }
              },
            ),
          );
        },
      );

      if (qrText == null) {
        if (_isContextValid(context)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không quét được QR Code')),
          );
        }
        return;
      }

      final List<dynamic> jsonList = jsonDecode(qrText);

      if (jsonList.isNotEmpty) {
        int importedCount = 0;
        int skippedCount = 0;

        for (final productData in jsonList) {
          if (productData is Map<String, dynamic>) {
            final newProduct = Product.fromMap(productData);

            if (productsList.findProductByID(newProduct.productID ?? '') !=
                null) {
              skippedCount++;
              continue;
            }

            productsList.addProduct(newProduct);
            importedCount++;
          }
        }

        if (_isContextValid(context)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã nhập $importedCount sản phẩm mới. Bỏ qua $skippedCount sản phẩm trùng.',
              ),
            ),
          );
        }
      } else {
        if (_isContextValid(context)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR Code không chứa sản phẩm hợp lệ')),
          );
        }
      }
    } catch (e) {
      if (_isContextValid(context)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi nhập QR Code: $e')));
      }
    }
  }

  // Export products to JSON file
  Future<void> _exportToJson(BuildContext context) async {
    try {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        if (_isContextValid(context)) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Không chọn thư mục')));
        }
        return;
      }

      final fileName = _generateFileName();
      final file = File('$selectedDirectory/$fileName');

      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      if (!await file.exists()) {
        await file.create();
      }

      final jsonData = productsList.allProducts.map((p) => p.toMap()).toList();
      await file.writeAsString(jsonEncode(jsonData));

      if (_isContextValid(context)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đã xuất dữ liệu ra $fileName')));
      }
    } catch (e) {
      if (_isContextValid(context)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi xuất JSON: $e')));
      }
    }
  }

  // Remove all products
  void _removeAllProducts(BuildContext context) {
    final productIds = productsList.allProducts.map((p) => p.productID).toList();
    for (final id in productIds) {
      if (id != null) productsList.deleteProduct(id);
    }
    if (_isContextValid(context)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa tất cả sản phẩm')));
    }
  }

  // Confirm remove all products
  void _showRemoveAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Xóa tất cả sản phẩm'),
            content: const Text(
              'Bạn có chắc chắn muốn xóa tất cả sản phẩm? Hành động này không thể hoàn tác.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Không'),
              ),
              TextButton(
                onPressed: () {
                  _removeAllProducts(context);
                  Navigator.pop(dialogContext);
                },
                child: const Text('Có'),
              ),
            ],
          ),
    );
  }

  // Manual add new product
  void _addProductManually(BuildContext context) async {
    final newProduct = Product();
    productsList.addProduct(newProduct);

    final result = await Navigator.pushNamed(
      context,
      '/productProperties',
      arguments: productsList.allProducts.indexOf(newProduct), // Không truyền index vì đây là thêm mới
    );
    productsList.removeByIndex(productsList.allProducts.indexOf(newProduct));
    
    if (result is Product) {
      productsList.addProduct(result);
      if (_isContextValid(context)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã thêm sản phẩm mới')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Tiện ích / Thiết lập',
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      //   ),
      //   backgroundColor: const Color(0xFF006A71),
      // ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Tiện ích',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Nhập sản phẩm thủ công'),
                  onTap: () => _addProductManually(context),
                ),
                ListTile(
                  leading: const Icon(Icons.file_download),
                  title: const Text('Nhập dữ liệu sản phẩm từ JSON'),
                  onTap: () => _importFromJson(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.qr_code_scanner),
                  title: const Text('Nhập dữ liệu sản phẩm từ QR Code'),
                  onTap: () => _importFromQrCode(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: const Text('Xuất dữ liệu sản phẩm ra JSON'),
                  onTap: () => _exportToJson(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Xóa tất cả sản phẩm',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => _showRemoveAllConfirmation(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Thiết lập',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Card(
            elevation: 2,
            child: ListTile(
              title: Text('Chưa có thiết lập nào'),
              subtitle: Text(
                'Khu vực này được dành cho các thiết lập trong tương lai.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
