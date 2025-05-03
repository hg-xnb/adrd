import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  final TextEditingController dacDiemController = TextEditingController();
  final TextEditingController coSoSXController = TextEditingController();
  final String thongTin = 'Thông tin chi tiết sản phẩm sẽ hiện ở đây.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dacDiemController,
              decoration: InputDecoration(labelText: 'Đặc điểm'),
            ),
            TextField(
              controller: coSoSXController,
              decoration: InputDecoration(labelText: 'Cơ sở sản xuất'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(thongTin),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Lưu')),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
              ],
            )
          ],
        ),
      ),
    );
  }
}