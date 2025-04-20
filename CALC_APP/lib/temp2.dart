import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Lớp này là root widget của ứng dụng. Mọi widget khác sẽ được xây dựng từ đây.
/// Lớp này kế thừa từ StatelessWidget, có nghĩa là nó không thay đổi trạng thái của mình.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
	/// là widget chính của Flutter, dùng để cấu hình ứng dụng với các chủ đề, cấu hình màn hình chính, v.v.
    /// MyApp khởi tạo MaterialApp
	return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

/// MyHomePage là widget có trạng thái (state), do đó ta cần sử dụng StatefulWidget. Đây là widget nơi mà trạng thái ứng dụng (số đếm) thay đổi khi người dùng tương tác (nhấn nút).
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // Biến lưu trữ số đếm
  int _counter = 0;

  void _descreamentCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--; // Giảm giá trị của _counter
      }
    });
  }

  // Hàm này gọi khi nhấn nút
  void _incrementCounter() {
    setState(() {
      _counter++; // Tăng giá trị của _counter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tích nghiệp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Số lần bạn tích nghiệp:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$_counter', // Hiển thị số đếm
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('+1 tích nghiệp'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _descreamentCounter,
              child: const Text('-1 tích nghiệp'),
            ),
          ],
        ),
      ),
    );
  }
}
