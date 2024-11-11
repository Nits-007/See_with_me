import 'package:flutter/material.dart';
import 'package:see_with_me/ObjectDetectionWithNavigation/navigation.dart';
import 'package:see_with_me/ObjectDetectionWithNavigation/objdet.dart';
import 'package:see_with_me/frontend/LastPage.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:see_with_me/frontend/Login_Page.dart';
import 'package:camera/camera.dart';
import 'package:see_with_me/frontend/Profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email id', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    }
    return null;
  }

  void showOptionsDialog(
      BuildContext context, List<CameraDescription> cameras) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.navigation, color: Colors.blue),
                title: Text('Voice Navigation with Object Detection'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NavigationScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.green),
                title: Text('Real-Time Object Detection with Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (cameras.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(camera: cameras.first),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No cameras available')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _command = val.recognizedWords;
            if (_command.toLowerCase().contains('call')) {
              _makeCall();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _makeCall() {
    FlutterPhoneDirectCaller.callNumber('********');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching cameras: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<CameraDescription>? cameras = snapshot.data;
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.deepPurple],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Home Page',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 34),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            border: Border.all(color: Colors.white30, width: 2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: 150,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            leading:
                                Icon(Icons.navigation, color: Colors.white),
                            title: Text(
                                'Voice Navigation with Object Detection',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Ahem')),
                            onTap: () {
                              showOptionsDialog(context, cameras!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 50),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 600,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: _makeCall,
                  ),
                ),
                Positioned(
                  top: 600,
                  left: 20,
                  child: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: _listen,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No cameras found'));
          }
        },
      ),
    );
  }
}
