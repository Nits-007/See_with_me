import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(camera: camera),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  HomeScreen({required this.camera});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late WebSocketChannel _channel;
  late StreamController<Uint8List> _processedImageStreamController;
  late FlutterTts flutterTts;
  String _detectionText = '';
  bool isProcessing = false;
  Timer? _reconnectTimer;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _startImageStream();
    });

    _connectToWebSocket();
    flutterTts = FlutterTts();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://realtimeobjectdet.onrender.com/ws/realtime-detection'),
    );

    _processedImageStreamController = StreamController<Uint8List>();

    _channel.stream.listen((data) {
      try {
        if (data is Uint8List) {
          _processedImageStreamController.add(data);
        } else {
          final detectRes = jsonDecode(data);
          String detectionText = _buildDetectionText(detectRes);
          setState(() {
            _detectionText = detectionText;
          });
          _speakDetectionResults(detectionText);
        }
        isProcessing = false;
      } catch (e) {
        print("Error processing received data: $e");
        isProcessing = false;
      }
    }, onError: (error) {
      print("WebSocket error: $error");
      _reconnectWebSocket();
    }, onDone: () {
      print("WebSocket connection closed");
      _reconnectWebSocket();
    });
  }

  void _reconnectWebSocket() {
    if (_reconnectTimer?.isActive ?? false) {
      _reconnectTimer?.cancel();
    }
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (_) {
      print("Attempting to reconnect...");
      _connectToWebSocket();
    });
  }

  void _startImageStream() {
    int frameCounter = 0;
    _controller.startImageStream((CameraImage image) async {
      frameCounter++;
      if (image == null || isProcessing || frameCounter % 2 != 0) return;

      isProcessing = true;

      img.Image convertedImage = _convertYUV420ToImage(image);

      List<int> jpeg = img.encodeJpg(convertedImage);

      _channel.sink.add(Uint8List.fromList(jpeg));
    });
  }

  img.Image _convertYUV420ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final img.Image imgImage = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      final int uvRowIndex = (y >> 1) * uvRowStride;
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvRowIndex + (x >> 1) * uvPixelStride;

        final int index = y * width + x;
        final int yp = image.planes[0].bytes[index];
        final int up = image.planes[1].bytes[uvIndex];
        final int vp = image.planes[2].bytes[uvIndex];

        int r = (yp + 1.402 * (vp - 128)).clamp(0, 255).toInt();
        int g = (yp - 0.344136 * (up - 128) - 0.714136 * (vp - 128))
            .clamp(0, 255)
            .toInt();
        int b = (yp + 1.772 * (up - 128)).clamp(0, 255).toInt();

        img.Color cl = img.ColorRgb8(r, g, b);

        imgImage.setPixel(x, y, cl);
      }
    }

    return img.copyRotate(imgImage, angle: 90);
  }

  String _buildDetectionText(List<dynamic> detections) {
    if (detections.isEmpty) {
      return "No objects detected.";
    }

    Map<String, Map<String, int>> categorizedObjects = {
      "left": {},
      "center": {},
      "right": {},
    };

    for (var detection in detections) {
      String label = detection['label'];
      String position = detection['position'];

      if (categorizedObjects[position]!.containsKey(label)) {
        categorizedObjects[position]![label] =
            categorizedObjects[position]![label]! + 1;
      } else {
        categorizedObjects[position]![label] = 1;
      }
    }

    List<String> detectionTexts = [];

    categorizedObjects.forEach((position, objects) {
      objects.forEach((label, count) {
        String text = "$count $label at the $position";
        detectionTexts.add(text);
      });
    });

    return detectionTexts.join(", ");
  }

  Future<void> _speakDetectionResults(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    _processedImageStreamController.close();
    _reconnectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real-Time Object Detection')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: CameraPreview(_controller),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _detectionText,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<Uint8List>(
              stream: _processedImageStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Processing...'));
                }
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data!);
                }
                return Center(child: Text('No Image'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
