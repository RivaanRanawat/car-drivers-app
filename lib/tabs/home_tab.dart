import 'dart:async';

import 'package:car_driver_app/helpers/pushNotificationService.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:car_driver_app/widgets/confirm_sheet.dart";

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  Position currentPos;
  DatabaseReference tripReqRef;
  String availabilityText = "GO ONLINE";
  Color availabilityColor = UniversalVariables.colorOrange;

  bool isAvailable = false;

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

  void getCurrentDriverInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser();
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize();
    pushNotificationService.getToken();    
  }

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
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
                  text: availabilityText,
                  color: availabilityColor,
                  onPressed: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                        title: (!isAvailable) ? "GO ONLINE" : "GO OFFLINE",
                        subtitle: (!isAvailable)
                            ? "You are about to become available to recieve trip requests"
                            : "You will stop receiving new trip requests",
                        onPressed: () {
                          if (!isAvailable) {
                            goOnline();
                            getLocationUpdates();
                            Navigator.of(context).pop();

                            setState(() {
                              availabilityColor = UniversalVariables.colorGreen;
                              availabilityText = "GO OFFLINE";
                              isAvailable = true;
                            });
                          } else {
                            goOffline();
                            Navigator.of(context).pop();

                            setState(() {
                              availabilityColor =
                                  UniversalVariables.colorOrange;
                              availabilityText = "GO ONLINE";
                              isAvailable = false;
                            });
                          }
                        },
                      ),
                    );
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

  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    tripReqRef.onDisconnect();
    tripReqRef.remove();
    tripReqRef = null;
  }

  void getLocationUpdates() {
    homeTabPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      currentPos = position;

      if (isAvailable) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
