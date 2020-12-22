import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  static const String id = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            DatabaseReference ref = FirebaseDatabase.instance.reference().child("testing");
            ref.set("testing connection");
          },
          minWidth: 200,
          color: Colors.blue,
          child: Text("Hello"),
        ),
      ),
    );
  }
}