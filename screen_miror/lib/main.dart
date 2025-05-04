import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MJPEGViewerApp());
}

class MJPEGViewerApp extends StatelessWidget {
  const MJPEGViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MJPEGHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MJPEGHome extends StatefulWidget {
  const MJPEGHome({super.key});

  @override
  State<MJPEGHome> createState() => _MJPEGHomeState();
}

class _MJPEGHomeState extends State<MJPEGHome> {
  final TextEditingController _urlController =
      TextEditingController(text: 'http://127.0.0.1:8082'); // default
  http.Client? _client;
  StreamSubscription<List<int>>? _subscription;
  Uint8List? _imageBytes;
  bool _isConnecting = false;
  bool _isConnected = false;
  final List<String> _logLines = [];

  void _appendLog(String msg) {
    setState(() {
      _logLines.add(msg);
    });
    debugPrint(msg);
  }

  void _connectStream() async {
    if (_isConnecting) return;
    setState(() => _isConnecting = true);

    _appendLog("🔌 Đang kết nối tới: ${_urlController.text}");

    _client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(_urlController.text));
      final response = await _client!.send(request);

      if (response.statusCode != 200) {
        _appendLog("❌ Server trả về mã ${response.statusCode}");
        _disconnect();
        return;
      }

      List<int> buffer = [];
      bool inImage = false;

      _subscription = response.stream.listen((chunk) {
        for (final byte in chunk) {
          if (byte == 0xFF && buffer.isNotEmpty && buffer.last == 0xD9) {
            inImage = false;
            buffer.add(byte);
            setState(() {
              _imageBytes = Uint8List.fromList(buffer);
              _isConnected = true;
            });
            buffer.clear();
          } else if (!inImage && byte == 0xFF) {
            inImage = true;
            buffer = [byte];
          } else if (inImage) {
            buffer.add(byte);
          }
        }
      }, onDone: () {
        _appendLog("✅ Kết nối kết thúc.");
        _disconnect();
      }, onError: (err) {
        _appendLog("❗ Lỗi kết nối: $err");
        _disconnect();
      });

      _appendLog("📡 Đã kết nối!");
    } catch (e) {
      _appendLog("❗ Lỗi ngoại lệ: $e");
      _disconnect();
    }
  }

  void _disconnect() {
    _subscription?.cancel();
    _client?.close();
    setState(() {
      _isConnecting = false;
      _isConnected = false;
      _subscription = null;
      _client = null;
      _imageBytes = null;
    });
    _appendLog("⛔ Đã ngắt kết nối.");
  }

  @override
  void dispose() {
    _disconnect();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected && _imageBytes != null) {
      // === Giao diện full screen khi đã kết nối ===
      return Scaffold(
        body: Stack(
          children: [
            Center(child: Image.memory(_imageBytes!)),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.red,
                onPressed: _disconnect,
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      );
    }

    // === Giao diện trước khi kết nối thành công ===
    return Scaffold(
      appBar: AppBar(title: const Text("MJPEG Stream Viewer")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "MJPEG URL (VD: http://127.0.0.1:8082)",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                onPressed: _isConnecting ? null : _connectStream,
                label: const Text("Kết nối"),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                onPressed: _isConnecting ? _disconnect : null,
                label: const Text("Ngắt"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Log trạng thái:", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black12,
              child: ListView.builder(
                itemCount: _logLines.length,
                itemBuilder: (context, index) {
                  return Text(_logLines[index], style: const TextStyle(fontSize: 13));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
