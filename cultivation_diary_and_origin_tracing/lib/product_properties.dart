import 'package:flutter/material.dart';
import 'new_definations.dart';
import 'package:intl/intl.dart';

class ProductProperties extends StatefulWidget {
  final int index;
  const ProductProperties({super.key, required this.index});

  @override
  State<ProductProperties> createState() => _ProductPropertiesState();
}

class _ProductPropertiesState extends State<ProductProperties> {
  late TextEditingController _nameController;
  late TextEditingController _originController;
  late TextEditingController _infoController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _importTimeController;
  late TextEditingController _exportTimeController;
  late Product? product;

  @override
  void initState() {
    super.initState();
    // Fetch the product using the index
    product = productsList.getElementAtIndex(widget.index);
    if (product == null) {
      // Handle case where product is null (e.g., invalid index)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      // Initialize with empty controllers
      _nameController = TextEditingController();
      _originController = TextEditingController();
      _infoController = TextEditingController();
      _priceController = TextEditingController();
      _categoryController = TextEditingController();
      _importTimeController = TextEditingController();
      _exportTimeController = TextEditingController();
    } else {
      // Initialize controllers with existing product data
      _nameController = TextEditingController(text: product!.name ?? '');
      _originController = TextEditingController(text: product!.origin ?? '');
      _infoController = TextEditingController(text: product!.info ?? '');
      _priceController = TextEditingController(
        text: product!.price?.toString() ?? '',
      );
      _categoryController = TextEditingController(
        text: product!.category ?? '',
      );
      _importTimeController = TextEditingController(
        text:
            product!.importTime != null
                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(product!.importTime!)
                : '',
      );
      _exportTimeController = TextEditingController(
        text:
            product!.exportTime != null
                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(product!.exportTime!)
                : '',
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _originController.dispose();
    _infoController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _importTimeController.dispose();
    _exportTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(
    BuildContext context,
    TextEditingController controller,
    DateTime? initialDateTime,
  ) async {
    DateTime initialDate = initialDateTime ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!context.mounted) return;

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (!context.mounted) return;

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.text = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(fullDateTime);
      }
    }
  }

  void _saveProduct() {
    if (product == null) return; // Prevent saving if product is null

    final updatedProduct = Product(
      productID: product!.productID, // Keep original productID
      name: _nameController.text.isEmpty ? product!.name : _nameController.text,
      origin:
          _originController.text.isEmpty
              ? product!.origin
              : _originController.text,
      info: _infoController.text.isEmpty ? product!.info : _infoController.text,
      price:
          _priceController.text.isEmpty
              ? product!.price
              : double.tryParse(_priceController.text),
      category:
          _categoryController.text.isEmpty
              ? product!.category
              : _categoryController.text,
      importTime:
          _importTimeController.text.isEmpty
              ? product!.importTime
              : DateTime.tryParse(_importTimeController.text),
      exportTime:
          _exportTimeController.text.isEmpty
              ? product!.exportTime
              : DateTime.tryParse(_exportTimeController.text),
    );

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product ID (read-only)
              TextFormField(
                initialValue: product?.productID ?? '',
                decoration: const InputDecoration(
                  labelText: 'Mã Sản Phẩm',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên Sản Phẩm',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Origin
              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(
                  labelText: 'Xuất Xứ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Info
              TextFormField(
                controller: _infoController,
                decoration: const InputDecoration(
                  labelText: 'Thông Tin',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Category
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Danh Mục',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Import Time
              TextFormField(
                controller: _importTimeController,
                decoration: const InputDecoration(
                  labelText: 'Thời Gian Nhập',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap:
                    () => _selectDateTime(
                      context,
                      _importTimeController,
                      product?.importTime,
                    ),
              ),
              const SizedBox(height: 16),
              // Export Time
              TextFormField(
                controller: _exportTimeController,
                decoration: const InputDecoration(
                  labelText: 'Thời Gian Xuất',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap:
                    () => _selectDateTime(
                      context,
                      _exportTimeController,
                      product?.exportTime,
                    ),
              ),

              const SizedBox(height: 24),
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
                    onPressed: product == null ? null : _saveProduct,
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
      ),
    );
  }
}
