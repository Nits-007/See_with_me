import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final TextEditingController addressController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  Position? _currentPosition;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  List<Map<String, dynamic>>? _steps;
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _speak(
            'Location permissions are denied. Please grant permission.');
        print('Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _speak(
          'Location permissions are permanently denied. Please grant permission in settings.');
      print('Location permission permanently denied.');
      return;
    }

    if (await Geolocator.isLocationServiceEnabled() == false) {
      await _speak('Location services are disabled. Please enable them.');
      print('Location services are disabled.');
      return;
    }

    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      print('Current Location: $_currentPosition');
    } catch (e) {
      await _speak('Error fetching the current location: $e');
      print('Error fetching location: $e');
    }
  }

  Future<void> _startNavigation() async {
    String address = addressController.text;

    if (_currentPosition == null) {
      await _speak('Unable to fetch current location. Please try again.');
      print('Current location is null.');
      return;
    }

    final String apiKey =
        '*********';
    final String start =
        '${_currentPosition!.longitude},${_currentPosition!.latitude}';
    print('Starting Location Coordinates: $start');

    final geoUrl =
        'https://nominatim.openstreetmap.org/search?format=json&q=$address';
    final geoResponse = await http.get(Uri.parse(geoUrl));
    final geoData = json.decode(geoResponse.body);

    if (geoData.isEmpty) {
      await _speak('Could not find the destination. Please check your input.');
      print('Geocoding API did not return any results.');
      return;
    }

    final String end = '${geoData[0]['lon']},${geoData[0]['lat']}';
    print('Destination Location Coordinates: $end');

    final String url =
        'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=$apiKey&start=$start&end=$end';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    print('Data received from API: ${json.encode(data)}');

    if (response.statusCode == 200 && data['features'].isNotEmpty) {
      List steps = data['features'][0]['properties']['segments'][0]['steps'];
      _steps = steps.map((step) {
        return {
          'instruction': step['instruction'],
          'distance': step['distance'],
          'way_points': step['way_points'],
        };
      }).toList();
      _currentStepIndex = 0;
      _monitorLocation();
    } else {
      await _speak('Unable to fetch route. Please try again.');
      print('Routing API did not return a valid response.');
    }
  }

  void _monitorLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      if (_steps != null && _currentStepIndex < _steps!.length) {
        double stepDistance = _steps![_currentStepIndex]['distance'];
        double currentDistance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        if (currentDistance <= stepDistance) {
          _speak(_steps![_currentStepIndex]['instruction']);
          _currentStepIndex++;
        }
      }
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            addressController.text = result.recognizedWords;
            _isListening = false;
          });
        });
      } else {
        print("Speech recognition not available");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Navigation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: addressController,
              decoration:
                  InputDecoration(labelText: 'Enter Destination Address'),
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              onPressed: _listen,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNavigation,
              child: Text('Start Navigation'),
            ),
          ],
        ),
      ),
    );
  }
}
