import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:see_with_me/frontend/Login_Page.dart';
import 'package:see_with_me/frontend/Signup_Page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool loginpage = true;

  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  void toggleScreen() {
    setState(() {
      loginpage = !loginpage;
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  _handleVoiceCommand(_text);
                }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _handleVoiceCommand(String command) {
    if (command.contains('navigate to')) {
      if (command.contains('login')) {
        setState(() => loginpage = true);
        _speak('Navigating to Login');
      } else if (command.contains('sign up')) {
        setState(() => loginpage = false);
        _speak('Navigating to Sign Up');
      }
    } else if (command.contains('click')) {
      if (command.contains('submit') || command.contains('sign up')) {
        if (!loginpage) {}
      } else if (command.contains('login')) {
        if (loginpage) {}
      }
    } else if (command.contains('enter')) {
      if (loginpage) {
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          loginpage
              ? LoginPage(signinpage: toggleScreen)
              : SigninPage(loginpage: toggleScreen),
        ],
      ),
    );
  }
}
