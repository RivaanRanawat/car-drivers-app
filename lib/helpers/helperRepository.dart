import 'dart:math';
import 'package:car_driver_app/helpers/requestHelpers.dart';
import 'package:car_driver_app/models/directionDetails.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelperRepository {
  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPos, LatLng endPos) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPos.latitude},${startPos.longitude}&destination=${endPos.latitude},${endPos.longitude}&mode=driving&key=${UniversalVariables.mapKey}";

    var response = await RequestHelpers.getRequest(url);

    if (response == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    // DURATION
    directionDetails.durationText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        response["routes"][0]["legs"][0]["duration"]["value"];

    // DISTANCE
    directionDetails.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        response["routes"][0]["legs"][0]["distance"]["value"];

    //Encoded Points
    directionDetails.encodedPoints =
        response["routes"][0]["overview_polyline"]["points"];

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details, int durationValue) {
    // Calculate fares:
    // BASE FARE(because rider sat in the vehicle) + DISTANCE FARE(amt for every km)+ TIME FARE(amt for every minute)
    // we will charge:
    // /km = ₹50
    // /minute = ₹10
    // base fare = ₹70

    double baseFare = 40;
    double distanceFare = (details.distanceValue / 1000) * 20;
    double timeFare = (durationValue / 60) * 5;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int radInt = randomGenerator.nextInt(max);
    return radInt.toDouble();
  }

  static void disableHomeTabLocUpdates() {
    homeTabPositionStream.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static void enableHomeTabLocationUpdates() {
    homeTabPositionStream.resume();
    Geofire.setLocation(
        currentFirebaseUser.uid, currentPos.latitude, currentPos.longitude);
  }

  static void showProgressDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Please wait...',
            ));
  }
}
