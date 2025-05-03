import 'package:flutter/material.dart';
import 'edit_card_properties.dart';
import 'package:photo_view/photo_view.dart';
import 'new_definations.dart';

class LogbookTab extends StatefulWidget {
  final List<FarmingLogEntry> entries;
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;
  final VoidCallback onAddEntry;

  const LogbookTab({
    super.key,
    required this.entries,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onAddEntry,
  });

  @override
  State<LogbookTab> createState() => _LogbookTabState();
}

class _LogbookTabState extends State<LogbookTab> {
  Future<void> _editField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
  }) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
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

  Widget _editableField(
    String label,
    String value,
    ValueChanged<String> onEdit,
  ) {
    return GestureDetector(
      onLongPress:
          () => _editField(
            title: 'Sửa $label',
            initialValue: value,
            onSaved: onEdit,
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.isEmpty ? '(chưa có)' : value)),
          ],
        ),
      ),
    );
  }

  Widget _editableDateField(
    String label,
    DateTime value,
    ValueChanged<DateTime> onEdit,
  ) {
    return GestureDetector(
      onLongPress: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onEdit(picked);
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                '${value.day}/${value.month}/${value.year} ${value.hour}:${value.minute}:${value.second}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashCard(FarmingLogEntry entry, int index) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (entry.currentImage != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => Scaffold(
                              appBar: AppBar(),
                              body: Center(
                                child: PhotoView(
                                  imageProvider: FileImage(entry.currentImage!),
                                  backgroundDecoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      ),
                    );
                  } else {
                    entry.pickImage(context).then((_) => setState(() {}));
                  }
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      entry.currentImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              entry.currentImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          : const Center(
                            child: Icon(Icons.add_a_photo, size: 48),
                          ),
                ),
              ),
              if (entry.images.length > 1) ...[
                Positioned(
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        entry.currentImageIndex =
                            (entry.currentImageIndex -
                                1 +
                                entry.images.length) %
                            entry.images.length;
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        entry.currentImageIndex =
                            (entry.currentImageIndex + 1) % entry.images.length;
                      });
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _editableDateField(
            'Thời gian ghi nhật ký',
            entry.entryDateTime,
            (v) => entry.entryDateTime = v,
          ),
          _editableField(
            'Giống cây',
            entry.cropVariety,
            (v) => entry.cropVariety = v,
          ),
          _editableField('Chăm sóc', entry.care, (v) => entry.care = v),
          _editableField(
            'Bón phân',
            entry.fertilizing,
            (v) => entry.fertilizing = v,
          ),
          _editableField(
            'Phun thuốc',
            entry.spraying,
            (v) => entry.spraying = v,
          ),
          _editableField(
            'Tưới nước (lít)',
            entry.wateringAmount.toString(),
            (v) => entry.wateringAmount = int.tryParse(v) ?? 0,
          ),
          _editableField(
            'Ghi chú tưới nước',
            entry.wateringNote,
            (v) => entry.wateringNote = v,
          ),
          _editableDateField(
            'Ngày thu hoạch',
            entry.harvestTime ?? DateTime(0),
            (v) => entry.harvestTime = v,
          ),
          _editableField(
            'Ghi chú thu hoạch',
            entry.harvestNote,
            (v) => entry.harvestNote = v,
          ),
          _editableField(
            'Bảo quản',
            entry.preservation,
            (v) => entry.preservation = v,
          ),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  setState(() {
                    widget.entries.removeAt(index);
                  });
                } else if (value == 'edit') {
                  final updatedEntry = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditCardProperties(
                            index: index,
                            entries: widget.entries,
                          ),
                    ),
                  );
                  if (updatedEntry != null) {
                    setState(() {
                      widget.entries[index] = updatedEntry;
                    });
                  }
                }
              },
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Sửa')),
                    PopupMenuItem(value: 'delete', child: Text('Xóa')),
                  ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNavigator(int currentPage, int totalPages) {
    List<Widget> widgets = [];

    void addPage(int i) {
      widgets.add(
        GestureDetector(
          onTap: () {
            widget.pageController.jumpToPage(i);
            widget.onPageChanged(i);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: i == currentPage ? Colors.teal : Colors.transparent,
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: i == currentPage ? Colors.white : Colors.teal,
              ),
            ),
          ),
        ),
      );
    }

    if (totalPages <= 7) {
      for (int i = 0; i < totalPages; i++) addPage(i);
    } else {
      addPage(0);
      if (currentPage > 3) widgets.add(const Text('...'));

      int start = (currentPage - 1).clamp(1, totalPages - 3);
      int end = (currentPage + 1).clamp(1, totalPages - 2);
      for (int i = start; i <= end; i++) addPage(i);

      if (currentPage < totalPages - 4) widgets.add(const Text('...'));
      addPage(totalPages - 1);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: widget.pageController,
            itemCount: widget.entries.length,
            onPageChanged: widget.onPageChanged,
            itemBuilder:
                (context, index) =>
                    _buildFlashCard(widget.entries[index], index),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._buildPageNavigator(
                  widget.currentPage,
                  widget.entries.length,
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  tooltip: 'Tạo thẻ mới',
                  onPressed: () {
                    setState(() {
                      widget.entries.add(FarmingLogEntry());
                      widget.pageController.jumpToPage(
                        widget.entries.length - 1,
                      );
                      widget.onPageChanged(widget.entries.length - 1);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
