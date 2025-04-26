import 'package:flutter/material.dart';
import 'new_definations.dart';

class ProductProperties extends StatefulWidget {
  final int index; // Changed from double to int
  const ProductProperties({super.key, required this.index});

  @override
  State<ProductProperties> createState() => _ProductPropertiesState();
}

class _ProductPropertiesState extends State<ProductProperties> {
  late TextEditingController _nameController;
  late TextEditingController _infoController;
  late TextEditingController _categoryController;
  late Product? product; // Changed to Product? to handle nullable return

  @override
  void initState() {
    super.initState();
    // Fetch the product using the index
    product = productList.getElementAtIndex(widget.index);
    if (product == null) {
      // Handle case where product is null (e.g., invalid index)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context); // Or show an error screen
      });
      // Initialize with empty controllers to avoid null access during build
      _nameController = TextEditingController();
      _infoController = TextEditingController();
      _categoryController = TextEditingController();
    } else {
      // Initialize controllers with existing product data
      _nameController = TextEditingController(text: product!.name ?? '');
      _infoController = TextEditingController(text: product!.info ?? '');
      _categoryController = TextEditingController(text: product!.category ?? '');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _infoController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (product == null) return; // Prevent saving if product is null
    // Create a new Product with updated values
    final updatedProduct = Product(
      productID: product!.productID, // Keep original productID
      name: _nameController.text.isEmpty ? null : _nameController.text,
      info: _infoController.text.isEmpty ? null : _infoController.text,
      category: _categoryController.text.isEmpty ? null : _categoryController.text,
      importTime: product!.importTime, // Keep original importTime
    );
    // Return the updated product to the previous screen
    Navigator.pop(context, updatedProduct);
  }

  void _cancel() {
    // Discard changes and return to previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Sản Phẩm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF006A71),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên Sản Phẩm',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _infoController,
              decoration: const InputDecoration(
                labelText: 'Thông Tin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Danh Mục',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: product == null ? null : _saveProduct, // Disable if product is null
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006A71),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}