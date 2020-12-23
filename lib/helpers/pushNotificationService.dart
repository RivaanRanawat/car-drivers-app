import 'dart:io';

import 'package:car_driver_app/models/tripDetails.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/notification_dialog.dart';
import 'package:car_driver_app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize(context) async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideId(message), context);
      },
    );
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print("token: $token");
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child("drivers/${currentFirebaseUser.uid}/$token");
    tokenRef.set(token);

    fcm.subscribeToTopic("allDrivers");
    fcm.subscribeToTopic("allUsers");
  }

  String getRideId(Map<String, dynamic> message) {
    String rideId = "";
    if (Platform.isAndroid) {
      rideId = message["data"]["ride_id"];
      print("rideId: $rideId");
    }

    return rideId;
  }

  void fetchRideInfo(String rideId, context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(status: "Fetching Details"));

    print("ride id:" + rideId);
    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child("rideRequest/$rideId");
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.of(context).pop();
      if (snapshot.value != null) {
        double pickupLat =
            double.parse(snapshot.value["location"]["latitude"].toString());
        double pickupLng =
            double.parse(snapshot.value["location"]["longitude"].toString());
        String pickupAddress = snapshot.value["pickup_address"].toString();

        double destinationLat =
            double.parse(snapshot.value["destination"]["latitude"].toString());
        double destinationLng =
            double.parse(snapshot.value["destination"]["longitude"].toString());
        String destinationAddress =
            snapshot.value["destination_address"].toString();

        String paymentMethod = snapshot.value["payment_method"];

        TripDetails tripDetails = TripDetails();
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.rideId = rideId;

        showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) =>
                            NotificationDialog(tripDetails));
      }
    });
  }
}
