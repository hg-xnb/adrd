import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final viewedProducts = ['Sản phẩm A', 'Sản phẩm B', 'Sản phẩm C', 'Sản phẩm D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử đã xem')),
      body: ListView.builder(
        itemCount: viewedProducts.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(viewedProducts[index]),
          onTap: () => Navigator.pushNamed(context, '/product'),
        ),
      ),
    );
  }
}


