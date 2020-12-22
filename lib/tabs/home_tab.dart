import 'dart:async';

import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  Position currentPos;
  DatabaseReference tripReqRef;

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  void getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPos = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: UniversalVariables.googlePlex,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete();
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: UniversalVariables.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 200,
                child: ReusableButton(
                  text: "GO ONLINE",
                  color: UniversalVariables.colorOrange,
                  onPressed: () {
                    goOnline();
                    getLocationUpdates();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void goOnline() {
    Geofire.initialize("driversAvailable");
    Geofire.setLocation(
        currentFirebaseUser.uid, currentPos.latitude, currentPos.longitude);

    tripReqRef = FirebaseDatabase.instance
        .reference()
        .child("drivers/${currentFirebaseUser.uid}/newTrip");
    tripReqRef.set("waiting");

    tripReqRef.onValue.listen((event) {});
  }

  void getLocationUpdates() {
    homeTabPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      currentPos = position;
      Geofire.setLocation(
          currentFirebaseUser.uid, position.latitude, position.longitude);

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
