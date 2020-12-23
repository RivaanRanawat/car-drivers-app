import 'package:car_driver_app/models/tripDetails.dart';
import "package:flutter/material.dart";

class NewTripsScreen extends StatefulWidget {
  final TripDetails tripDetails;
  NewTripsScreen(this.tripDetails);
  
  @override
  _NewTripsScreenState createState() => _NewTripsScreenState();
}

class _NewTripsScreenState extends State<NewTripsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Trip"),
      ),
    );
  }
}