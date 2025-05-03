import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'new_definations.dart';

class EditCardProperties extends StatefulWidget {
  final int index;
  final List<FarmingLogEntry> entries;

  const EditCardProperties({super.key, required this.index, required this.entries});

  @override
  State<EditCardProperties> createState() => _EditCardPropertiesState();
}

class _EditCardPropertiesState extends State<EditCardProperties> {
  late FarmingLogEntry entry;
  late TextEditingController _cropController;
  late TextEditingController _careController;
  late TextEditingController _fertilizingController;
  late TextEditingController _sprayingController;
  late TextEditingController _wateringAmountController;
  late TextEditingController _wateringNoteController;
  late TextEditingController _harvestNoteController;
  late TextEditingController _preservationController;
  late TextEditingController _entryDateTimeController;
  late TextEditingController _harvestTimeController;

  @override
  void initState() {
    super.initState();
    entry = widget.entries[widget.index];
    _cropController = TextEditingController(text: entry.cropVariety);
    _careController = TextEditingController(text: entry.care);
    _fertilizingController = TextEditingController(text: entry.fertilizing);
    _sprayingController = TextEditingController(text: entry.spraying);
    _wateringAmountController = TextEditingController(text: entry.wateringAmount.toString());
    _wateringNoteController = TextEditingController(text: entry.wateringNote);
    _harvestNoteController = TextEditingController(text: entry.harvestNote);
    _preservationController = TextEditingController(text: entry.preservation);
    _entryDateTimeController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm:ss').format(entry.entryDateTime),
    );
    _harvestTimeController = TextEditingController(
      text: entry.harvestTime != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(entry.harvestTime!)
          : '',
    );
  }

  Future<void> _selectDateTime(TextEditingController controller, DateTime? current) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current ?? DateTime.now()),
    );
    if (pickedTime == null) return;

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime);
  }

  void _save() {
    entry.cropVariety = _cropController.text;
    entry.care = _careController.text;
    entry.fertilizing = _fertilizingController.text;
    entry.spraying = _sprayingController.text;
    entry.wateringAmount = int.tryParse(_wateringAmountController.text) ?? 0;
    entry.wateringNote = _wateringNoteController.text;
    entry.harvestNote = _harvestNoteController.text;
    entry.preservation = _preservationController.text;
    entry.entryDateTime = DateTime.tryParse(_entryDateTimeController.text) ?? entry.entryDateTime;
    entry.harvestTime = DateTime.tryParse(_harvestTimeController.text);

    Navigator.pop(context, entry);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _cropController.dispose();
    _careController.dispose();
    _fertilizingController.dispose();
    _sprayingController.dispose();
    _wateringAmountController.dispose();
    _wateringNoteController.dispose();
    _harvestNoteController.dispose();
    _preservationController.dispose();
    _entryDateTimeController.dispose();
    _harvestTimeController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa nhật ký trồng trọt')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Giống cây', _cropController),
            _buildTextField('Chăm sóc', _careController),
            _buildTextField('Bón phân', _fertilizingController),
            _buildTextField('Phun thuốc', _sprayingController),
            _buildTextField('Tưới nước (lít)', _wateringAmountController),
            _buildTextField('Ghi chú tưới nước', _wateringNoteController),
            _buildTextField('Ghi chú thu hoạch', _harvestNoteController),
            _buildTextField('Bảo quản', _preservationController),
            _buildTextField(
              'Thời gian ghi nhật ký',
              _entryDateTimeController,
              readOnly: true,
              onTap: () => _selectDateTime(_entryDateTimeController, entry.entryDateTime),
            ),
            _buildTextField(
              'Ngày thu hoạch',
              _harvestTimeController,
              readOnly: true,
              onTap: () => _selectDateTime(_harvestTimeController, entry.harvestTime),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Lưu', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
