import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String rideId;
  String paymentMethod;
  String riderName;
  String riderPhone;

  TripDetails({
    this.destination,
    this.destinationAddress,
    this.paymentMethod,
    this.pickup,
    this.pickupAddress,
    this.rideId,
    this.riderName,
    this.riderPhone,
  });
}