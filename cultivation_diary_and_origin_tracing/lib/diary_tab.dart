import 'package:flutter/material.dart';
import 'edit_card_properties.dart';
import 'package:photo_view/photo_view.dart';
import 'new_definations.dart';
import 'package:collection/collection.dart';

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
  int _currentCardIndex = 0;
  final ScrollController _cardScrollController = ScrollController();

  Map<DateTime, List<FarmingLogEntry>> get _groupedEntries {
    return widget.entries.groupListsBy(
      (entry) => DateTime(
        entry.entryDateTime.year,
        entry.entryDateTime.month,
        entry.entryDateTime.day,
      ),
    );
  }

  List<DateTime> get _uniqueDays {
    final days = _groupedEntries.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    return days;
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

  Widget _editableField(
    String label,
    String value,
    ValueChanged<String> onEdit,
  ) {
    return GestureDetector(
      onLongPress: () => _editField(
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

  Widget _buildFlashCard(FarmingLogEntry entry, int dayIndex, int cardIndex) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (entry.currentImage != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
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
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add_a_photo),
                          title: const Text('Thêm ảnh'),
                          onTap: () async {
                            await entry.pickImage(context);
                            Navigator.pop(ctx);
                            setState(() {});
                          },
                        ),
                        if (entry.currentImage != null)
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Xóa ảnh hiện tại'),
                            onTap: () {
                              setState(() {
                                entry.images.removeAt(entry.currentImageIndex);
                                entry.currentImageIndex = entry.images.isNotEmpty
                                    ? entry.currentImageIndex.clamp(0, entry.images.length - 1)
                                    : 0;
                              });
                              Navigator.pop(ctx);
                            },
                          ),
                      ],
                    ),
                  );
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: entry.currentImage != null
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
              if (entry.images.isNotEmpty) ...[
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        entry.currentImageIndex =
                            (entry.currentImageIndex - 1 + entry.images.length) %
                                entry.images.length;
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
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
                    widget.entries.removeAt(cardIndex);
                  });
                } else if (value == 'edit') {
                  final updatedEntry = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditCardProperties(
                        index: cardIndex,
                        entries: widget.entries,
                      ),
                    ),
                  );
                  if (updatedEntry != null) {
                    setState(() {
                      widget.entries[cardIndex] = updatedEntry;
                    });
                  }
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Sửa')),
                PopupMenuItem(value: 'delete', child: Text('Xóa')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDayNavigator(int currentDay, List<DateTime> uniqueDays) {
    List<Widget> widgets = [];

    void addDay(int i) {
      widgets.add(
        GestureDetector(
          onTap: () {
            widget.pageController.jumpToPage(i);
            widget.onPageChanged(i);
            setState(() {
              _currentCardIndex = 0;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: i == currentDay ? Colors.teal : Colors.transparent,
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: i == currentDay ? Colors.white : Colors.teal,
              ),
            ),
          ),
        ),
      );
    }

    if (uniqueDays.length <= 7) {
      for (int i = 0; i < uniqueDays.length; i++) addDay(i);
    } else {
      addDay(0);
      if (currentDay > 3) widgets.add(const Text('...'));

      int start = (currentDay - 1).clamp(1, uniqueDays.length - 3);
      int end = (currentDay + 1).clamp(1, uniqueDays.length - 2);
      for (int i = start; i <= end; i++) addDay(i);

      if (currentDay < uniqueDays.length - 4) widgets.add(const Text('...'));
      addDay(uniqueDays.length - 1);
    }

    return widgets;
  }

  Widget _buildCardNavigator(int currentCard, int totalCards, int dayIndex) {
    List<Widget> widgets = [];

    void addCard(int i) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _currentCardIndex = i;
              _cardScrollController.animateTo(
                i * 400.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: i == currentCard ? Colors.teal : Colors.transparent,
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: i == currentCard ? Colors.white : Colors.teal,
              ),
            ),
          ),
        ),
      );
    }

    if (totalCards <= 5) {
      for (int i = 0; i < totalCards; i++) addCard(i);
    } else {
      addCard(0);
      if (currentCard > 3) widgets.add(const Text('...'));

      int start = (currentCard - 1).clamp(1, totalCards - 3);
      int end = (currentCard + 1).clamp(1, totalCards - 2);
      for (int i = start; i <= end; i++) addCard(i);

      if (currentCard < totalCards - 4) widgets.add(const Text('...'));
      addCard(totalCards - 1);
    }

    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widgets,
            IconButton(
              icon: const Icon(Icons.add, color: Colors.teal),
              tooltip: 'Tạo thẻ mới',
              onPressed: () {
                setState(() {
                  widget.entries.add(FarmingLogEntry(
                    entryDateTime: _uniqueDays[dayIndex],
                  ));
                  _currentCardIndex = totalCards;
                  _cardScrollController.animateTo(
                    totalCards * 400.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: widget.pageController,
                  itemCount: _uniqueDays.length,
                  onPageChanged: (index) {
                    widget.onPageChanged(index);
                    setState(() {
                      _currentCardIndex = 0;
                      _cardScrollController.jumpTo(0);
                    });
                  },
                  itemBuilder: (context, dayIndex) {
                    final dayEntries = _groupedEntries[_uniqueDays[dayIndex]] ?? [];
                    return ListView.builder(
                      controller: _cardScrollController,
                      itemCount: dayEntries.length,
                      itemBuilder: (context, cardIndex) {
                        return _buildFlashCard(dayEntries[cardIndex], dayIndex, cardIndex);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ..._buildDayNavigator(widget.currentPage, _uniqueDays),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.teal),
                        tooltip: 'Thêm ngày mới',
                        onPressed: () {
                          setState(() {
                            // Use current date or next day if there are existing entries
                            final newDate = _uniqueDays.isEmpty
                                ? DateTime.now()
                                : _uniqueDays.first.add(const Duration(days: 1));
                            final newEntry = FarmingLogEntry(
                              entryDateTime: newDate,
                            );
                            widget.entries.add(newEntry);
                            // Wait for state to update
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_uniqueDays.isNotEmpty) {
                                widget.pageController.jumpToPage(_uniqueDays.length - 1);
                                widget.onPageChanged(_uniqueDays.length - 1);
                              }
                              setState(() {
                                _currentCardIndex = 0;
                              });
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_uniqueDays.isNotEmpty)
          Center(
            child: _buildCardNavigator(
              _currentCardIndex,
              _groupedEntries[_uniqueDays[widget.currentPage]]?.length ?? 0,
              widget.currentPage,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _cardScrollController.dispose();
    super.dispose();
  }
}