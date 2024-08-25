See_with_me:
See_with_me is a Flutter application designed to assist users with real-time object detection, voice-controlled navigation, and other accessibility features. It leverages cutting-edge technologies like Firebase, YOLO object detection, and text-to-speech to create an intuitive and helpful experience for users.

Features:
1. Real-time Object Detection: Uses the camera to detect objects in real-time, providing voice feedback about the detected objects.
2. Voice Navigation: Users can navigate through the app using voice commands. The app provides voice-guided navigation instructions, helping users reach their destinations.
3. Firebase Authentication: Secure login and signup functionality with Firebase integration.
4. Direct Phone Calls: Users can make direct phone calls from the app using the phone number provided during signup.
5. Background Services: The app supports running certain features, like voice navigation, in the background.
6. Splash Screen: Features a splash screen with a Lottie animation and a welcome message that transitions to the main screen.

Screens:
1. Splash Screen: Displays an animated welcome screen before transitioning to the main page.
2. Login Page: Secure login with Firebase authentication, featuring voice control for entering email and password.
3. Signup Page: Register a new user account with Firebase, with voice-controlled input fields.
4. Home Page: A gradient background with navigable tiles leading to various app functions like voice navigation, object detection, and more.
5. Navigation Screen: Provides real-time, voice-guided navigation instructions, even when running in the background.
6. Object Detection Screen: Detects objects using the camera and provides real-time voice feedback.

Installation:
1. git clone https://github.com/yourusername/see_with_me.git
2. cd see_with_me
3. flutter pub get
4. flutter run

Configuration:
1. Firebase Setup: Ensure that your Firebase project is set up and connected with your Flutter app. Replace the google-services.json (for Android) and GoogleService-Info.plist (for iOS) with your Firebase project files.
2. Permissions: Update the AndroidManifest.xml file to include necessary permissions for camera, location, and phone calls. Also, ensure that iOS permissions are configured in the Info.plist file.
3. OpenRouteService API: Set up the OpenRouteService API for voice navigation. Ensure you have the API key and have configured it in the appropriate place in your code.

Contributing:
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

License:
This project is licensed under the MIT License - see the LICENSE file for details.

Contact:
For any questions or suggestions, please contact Nishant Singh (nits007) at nishant.sword17@gmail.com
