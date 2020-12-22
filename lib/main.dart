import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "./screens/home_screen.dart";
import "./screens/login_screen.dart";
import "./screens/signup_screen.dart";
import "dart:io";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialise database
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
            gcmSenderID: '297855924061',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          )
        : FirebaseOptions(
            googleAppID: '1:74445978662:android:4cea5c5cb0bb8e50163ae7',
            apiKey: 'AIzaSyDlN5S_ny58G9dUgtHIcJPt2HdFopOoDyQ',
            databaseURL: 'https://cab-rider-app-default-rtdb.firebaseio.com',
          ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Cab App',
      theme: ThemeData(
        fontFamily: "Nunito-Regular",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SignUpScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen()
      },
    );
  }
}
