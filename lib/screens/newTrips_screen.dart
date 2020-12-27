import 'dart:async';

import 'package:car_driver_app/helpers/helperRepository.dart';
import 'package:car_driver_app/helpers/mapKitHelper.dart';
import 'package:car_driver_app/models/tripDetails.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/collect_payment_dialog.dart';
import 'package:car_driver_app/widgets/progress_dialog.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripsScreen extends StatefulWidget {
  final TripDetails tripDetails;
  NewTripsScreen(this.tripDetails);

  @override
  _NewTripsScreenState createState() => _NewTripsScreenState();
}

class _NewTripsScreenState extends State<NewTripsScreen> {
  GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polyLines = Set<Polyline>();

  List<LatLng> polyLineCordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPaddingBottom = 0;

  String buttonTitle = "ARRIVED";
  Color buttonColor = UniversalVariables.colorGreen;

  var geoLocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  Position myPosition;

  BitmapDescriptor movingMarkerIcon;

  String status = "accepted";

  String durationString = "";
  bool isRequestingDirection = false;

  Timer timer;

  int durationCounter = 0;

  void createMarker() {
    if (movingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car_android.png")
          .then((value) {
        movingMarkerIcon = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    acceptTrip();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            initialCameraPosition: UniversalVariables.googlePlex,
            mapType: MapType.normal,
            circles: _circles,
            trafficEnabled: true,
            polylines: _polyLines,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete();
              rideMapController = controller;
              setState(() {
                mapPaddingBottom = 260;
              });

              var currentLatLng =
                  LatLng(currentPos.latitude, currentPos.longitude);
              var pickupLatLng = widget.tripDetails.pickup;

              print("current lat lng $currentLatLng");
              print("pickup lat lng $pickupLatLng");

              await getDirection(currentLatLng, pickupLatLng);
              getLocationUpdates();
            },
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 255,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      durationString,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Bolt-Semibold",
                          color: UniversalVariables.colorAccentPurple),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rivaan Ranawat",
                          style: TextStyle(
                              fontSize: 22, fontFamily: "Bolt-Semibold"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.call),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/pickicon.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              "Ashok Smruti Building",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/desticon.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              "CNMS",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    ReusableButton(
                      text: buttonTitle,
                      color: buttonColor,
                      onPressed: () async {
                        if(status == "accepted") {
                          status = "arrived";
                          rideRef.child("status").set(("arrived"));

                          setState(() {
                            buttonTitle = "START TRIP";
                            buttonColor = UniversalVariables.colorAccentPurple;
                          });

                          HelperRepository.showProgressDialog(context);
                          await getDirection(widget.tripDetails.pickup, widget.tripDetails.destination);
                          Navigator.of(context).pop();
                        } else if(status == "arrived") {
                          status = "onTrip";
                          rideRef.child("status").set("onTrip");
                          setState(() {
                            buttonTitle = "END TRIP";
                            buttonColor = Colors.red[900];
                          });
                          startTimer();
                        } else if(status == "onTrip") {
                          endTrip();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void acceptTrip() {
    String rideId = widget.tripDetails.rideId;
    rideRef =
        FirebaseDatabase.instance.reference().child("rideRequest/$rideId");
    rideRef.child("status").set("accepted");
    rideRef.child("driver_name").set(currentDriverInfo.fullName);
    rideRef
        .child("car_details")
        .set("${currentDriverInfo.carColour} - ${currentDriverInfo.carModel}");
    rideRef.child("driver_phone").set(currentDriverInfo.phone);
    rideRef.child("driver_id").set(currentDriverInfo.id);

    Map locationMap = {
      "latitude": currentPos.latitude.toString(),
      "longitude": currentPos.longitude.toString(),
    };

    rideRef.child("driver_location").set(locationMap);
  }

  void getLocationUpdates() {
    LatLng oldPosition = LatLng(0, 0);

    ridePositionStream = geoLocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      myPosition = position;
      currentPos = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(oldPosition.latitude,
          oldPosition.longitude, pos.latitude, pos.longitude);

      Marker movingMarker = Marker(
        markerId: MarkerId("moving"),
        position: pos,
        icon: movingMarkerIcon,
        rotation: rotation,
        infoWindow: InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 17);
        rideMapController.animateCamera(CameraUpdate.newCameraPosition(cp));

        _markers.removeWhere((element) => element.markerId.value == "moving");
        _markers.add(movingMarker);
      });

      oldPosition = pos;
      updateTripDetails();
      Map locationMap = {
        "latitude": myPosition.latitude.toString(),
        "longitude": myPosition.longitude.toString()
      };
      rideRef.child("driver_location").set(locationMap);
    });
  }

  void updateTripDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }
      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if (status == "accepted") {
        destinationLatLng = widget.tripDetails.pickup;
      } else {
        destinationLatLng = widget.tripDetails.destination;
      }

      var directionDetails = await HelperRepository.getDirectionDetails(
          positionLatLng, destinationLatLng);

      if (directionDetails != null) {
        setState(() {
          durationString = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  Future<void> getDirection(
      LatLng pickupLatLng, LatLng destinationLatLng) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Please wait...',
            ));

    var thisDetails = await HelperRepository.getDirectionDetails(
        pickupLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);
    polyLineCordinates.clear();

    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polyLineCordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polyLines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polyLineCordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLines.add(polyline);
    });

    // make polyline to fit into the map

    LatLngBounds bounds;

    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: UniversalVariables.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: UniversalVariables.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: UniversalVariables.colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void endTrip() async{
    timer.cancel();
    HelperRepository.showProgressDialog(context);
    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);
    var directionDetails= await HelperRepository.getDirectionDetails(widget.tripDetails.pickup, currentLatLng);
    Navigator.of(context).pop();
    int fares = HelperRepository.estimateFares(directionDetails, durationCounter);
    rideRef.child("fares").set(fares.toString());
    rideRef.child("status").set("ended");
    ridePositionStream.cancel();

    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => CollectPaymentDialog(
      paymentMethod: widget.tripDetails.paymentMethod,
      fares: fares
    ));
  }
}
