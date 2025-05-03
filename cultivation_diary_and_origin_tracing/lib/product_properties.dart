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
  late TextEditingController _quantityController;
  late TextEditingController _quantityUnitController;
  late TextEditingController _cultivationInfoController;
  late TextEditingController _productPropertiesController;

  late Product? product;

  @override
  void initState() {
    super.initState();
    product = productsList.getElementAtIndex(widget.index);

    if (product == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      _nameController = TextEditingController();
      _originController = TextEditingController();
      _infoController = TextEditingController();
      _priceController = TextEditingController();
      _categoryController = TextEditingController();
      _importTimeController = TextEditingController();
      _exportTimeController = TextEditingController();
      _quantityController = TextEditingController();
      _quantityUnitController = TextEditingController();
      _cultivationInfoController = TextEditingController();
      _productPropertiesController = TextEditingController();
    } else {
      _nameController = TextEditingController(text: product!.name ?? 'N/A');
      _originController = TextEditingController(text: product!.origin ?? 'N/A');
      _infoController = TextEditingController(text: product!.info ?? 'N/A');
      _priceController = TextEditingController(text: product!.price?.toString() ?? 'N/A');
      _categoryController = TextEditingController(text: product!.category ?? 'N/A');
      _importTimeController = TextEditingController(
        text: product!.importTime != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(product!.importTime!) : '',
      );
      _exportTimeController = TextEditingController(
        text: product!.exportTime != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(product!.exportTime!) : '',
      );
      _quantityController = TextEditingController(text: product!.quantity?.toString() ?? 'N/A');
      _quantityUnitController = TextEditingController(text: product!.quantityUnit ?? 'N/A');
      _cultivationInfoController = TextEditingController(text: product!.cultivationInfo ?? 'N/A');
      _productPropertiesController = TextEditingController(text: product!.productProperties ?? 'N/A');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _originController.dispose();
    _infoController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _importTimeController.dispose();
    _exportTimeController.dispose();
    _quantityController.dispose();
    _quantityUnitController.dispose();
    _cultivationInfoController.dispose();
    _productPropertiesController.dispose();
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

        controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime);
      }
    }
  }

  void _saveProduct() {
    if (product == null) return;

    final updatedProduct = Product(
      productID: product!.productID,
      name: _nameController.text,
      origin: _originController.text,
      info: _infoController.text,
      price: double.tryParse(_priceController.text),
      category: _categoryController.text,
      importTime: DateTime.tryParse(_importTimeController.text),
      exportTime: DateTime.tryParse(_exportTimeController.text),
      quantity: double.tryParse(_quantityController.text),
      quantityUnit: _quantityUnitController.text,
      cultivationInfo: _cultivationInfoController.text,
      productProperties: _productPropertiesController.text,
    );

    Navigator.pop(context, updatedProduct);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Sản Phẩm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFF006A71),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: product?.productID ?? 'N/A',
                decoration: const InputDecoration(
                  labelText: 'Mã Sản Phẩm',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              buildTextField(controller: _nameController, label: 'Tên Sản Phẩm'),
              buildTextField(controller: _categoryController, label: 'Danh Mục'),
              buildTextField(controller: _productPropertiesController, label: 'Tính Chất Sản Phẩm', maxLines: 2),
              buildTextField(controller: _cultivationInfoController, label: 'Thông Tin Canh Tác', maxLines: 2),
              buildTextField(controller: _originController, label: 'Xuất Xứ'),
              buildTextField(controller: _infoController, label: 'Thông Tin'),
              buildTextField(controller: _priceController, label: 'Giá', keyboardType: TextInputType.number),
              buildTextField(controller: _quantityUnitController, label: 'Đơn Vị'),
              buildTextField(controller: _quantityController, label: 'Số Lượng', keyboardType: TextInputType.number),
              buildTextField(
                controller: _importTimeController,
                label: 'Thời Gian Nhập',
                onTap: () => _selectDateTime(context, _importTimeController, product?.importTime),
              ),
              buildTextField(
                controller: _exportTimeController,
                label: 'Thời Gian Xuất',
                onTap: () => _selectDateTime(context, _exportTimeController, product?.exportTime),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _cancel,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    child: const Text('Hủy', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: product == null ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006A71)),
                    child: const Text('Lưu', style: TextStyle(color: Colors.white)),
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
