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
  String _text = 'Số lần bạn tích nghiệp';
  Color _appbarColor = Color(0xFF48A6A7);
  Color _bgColor = Color(0xFFF5EEDD);
  Color _mainText = Colors.white;

  void _updateText() {
    setState(() {
      if(_counter < 15){
        _text = 'Số lần bạn tích nghiệp';
        _appbarColor = Color(0xFF48A6A7);
        _bgColor = Color(0xFFF5EEDD);
        _mainText = Color(0xFF09122C);
      }
      else if(_counter < 30){
        _text = 'Nghiệp dữ rồi nhen ...';
        _appbarColor = Color(0xFF183B4E);
        _bgColor = Color(0xFFF5ECE0);
        _mainText = Color(0xFF09122C);
      }
      else if(_counter < 45){
        _text = 'Ê... nghiệp quá trời rồi :)';
        _appbarColor = Color(0xFF9F5255);
        _bgColor = Color(0xFFDEAA79);
        _mainText = Colors.black45;
      }else{
        _text = 'D** M* đồ nghiệp chướng!!!!!';
        _appbarColor = Color(0xFFA62C2C);
        _bgColor = Color(0xFFF7374F);
        _mainText = Colors.white;
      }
    });
  }

  void _giamNghiep() {
    setState(() {
      _counter -=1;
      _updateText();
    });
  }

  void _them10Nghiep() {
    setState(() {
      _counter += 10;
      _updateText();
    });
  }

  void _themNghiep() {
    setState(() {
      _counter++; // Tăng giá trị của _counter
      _updateText();
    });
  }

  void _hetNghiep() {
    setState(() {
      _counter = 0; // Đặt lại giá trị của _counter về 0
      _updateText();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: _appbarColor,
        title: const Text(
          'Tích nghiệp',
          style: TextStyle(color: Colors.white)
          ),
      ),
      backgroundColor: _bgColor,
      body: Center(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  color: _mainText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_counter', // Hiển thị số đếm
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 50,
                  color: _mainText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _themNghiep,
                onLongPress: _giamNghiep,
                child: const Text('+1 tích nghiệp'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: _them10Nghiep,
                onLongPress: _hetNghiep,
                child: const Text('-1 tích nghiệp'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
