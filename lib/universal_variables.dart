import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UniversalVariables {
// COLORS
  static const Color colorIcon = Color(0xFF666666);
  static const Color colorPrimary = Color(0xFF2B1A64);
  static const Color colorPrimaryDark = Color(0xFF1c3aa9);
  static const Color colorAccent = Color(0xFF21ba45);
  static const Color colorAccent1 = Color(0xFFe3fded);

  static const Color colorBackground = Color(0xFFFBFAFF);

  static const Color colorPink = Color(0xFFE66C75);
  static const Color colorOrange = Color(0xFFd16608);
  static const Color colorBlue = Color(0xFF2254A3);
  static const Color colorAccentPurple = Color(0xFF4f5cd1);

  static const Color colorText = Color(0xFF383635);
  static const Color colorTextLight = Color(0xFF918D8D);
  static const Color colorTextSemiLight = Color(0xFF737373);
  static const Color colorTextDark = Color(0xFF292828);

  static const Color colorGreen = Color(0xFF40cf89);
  static const Color colorLightGray = Color(0xFFe2e2e2);
  static const Color colorLightGrayFair = Color(0xFFe1e5e8);
  static const Color colorDimText = Color(0xFFadadad);

// API KEYS
  static const String mapKey = "AIzaSyDlN5S_ny58G9dUgtHIcJPt2HdFopOoDyQ";

// VARIABLES
  static final CameraPosition googlePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
FirebaseUser currentFirebaseUser;
StreamSubscription<Position> homeTabPositionStream;
