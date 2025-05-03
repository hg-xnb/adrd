import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FarmingLogEntry {
  File? image;
  String cropVariety;
  String care;
  String fertilizing;
  String spraying;
  int wateringAmount;
  String wateringNote;
  DateTime? harvestTime;
  String harvestNote;
  String preservation;

  FarmingLogEntry({
    this.image,
    this.cropVariety = '',
    this.care = '',
    this.fertilizing = '',
    this.spraying = '',
    this.wateringAmount = 0,
    this.wateringNote = '',
    this.harvestTime,
    this.harvestNote = '',
    this.preservation = '',
  });

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FarmingLogEntry> entries = [FarmingLogEntry(), FarmingLogEntry(), FarmingLogEntry()];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future<void> _editField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
  }) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              onSaved(controller.text);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashCard(FarmingLogEntry entry) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () async {
              await entry.pickImage();
              setState(() {});
            },
            child: entry.image != null
                ? Image.file(entry.image!, height: 200, fit: BoxFit.cover)
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.add_a_photo),
                  ),
          ),
          const SizedBox(height: 12),
          _editableField('Giống cây', entry.cropVariety, (v) => entry.cropVariety = v),
          _editableField('Chăm sóc', entry.care, (v) => entry.care = v),
          _editableField('Bón phân', entry.fertilizing, (v) => entry.fertilizing = v),
          _editableField('Phun thuốc', entry.spraying, (v) => entry.spraying = v),
          _editableField('Tưới nước (lít)', entry.wateringAmount.toString(), (v) => entry.wateringAmount = int.tryParse(v) ?? 0),
          _editableField('Ghi chú tưới nước', entry.wateringNote, (v) => entry.wateringNote = v),
          _editableField('Ghi chú thu hoạch', entry.harvestNote, (v) => entry.harvestNote = v),
          _editableField('Bảo quản', entry.preservation, (v) => entry.preservation = v),
        ],
      ),
    );
  }

  Widget _editableField(String label, String value, ValueChanged<String> onEdit) {
    return GestureDetector(
      onLongPress: () => _editField(title: 'Sửa $label', initialValue: value, onSaved: onEdit),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value.isEmpty ? '(chưa có)' : value)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhật Ký Trồng Trọt'),
        backgroundColor: const Color(0xFF006A71),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 0'),
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 0: flashcards
          PageView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) => _buildFlashCard(entries[index]),
          ),
          // Tab 1: chưa xử lý
          const Center(child: Text('Tab 1 - Chưa phát triển')),
          // Tab 2: chưa xử lý
          const Center(child: Text('Tab 2 - Chưa phát triển')),
        ],
      ),
    );
  }
}
