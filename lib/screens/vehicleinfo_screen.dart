import 'package:car_driver_app/screens/home_screen.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class VehicleInfoScreen extends StatelessWidget {
  static const String id = "vehicleInfo";

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var carModelController = TextEditingController();
  var carColourController = TextEditingController();
  var vehicleNumberController = TextEditingController();

  void showSnackBar(String title) {
    final snackBar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15)));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void updateProfile(context) {
    String id = currentFirebaseUser.uid;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child("drivers/$id/vehicle_details");

    Map map = {
      "car_colour": carColourController.text,
      "car_model": carModelController.text,
      "vehicle_number": vehicleNumberController.text
    };

    driverRef.set(map);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 130),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Column(
                  children: [
                    Text(
                      "Enter vehicle's details",
                      style: TextStyle(fontFamily: "Bolt-Bold", fontSize: 22),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: carColourController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Car Colour",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: vehicleNumberController,
                      maxLength: 11,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Vehicle Number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ReusableButton(
                      color: UniversalVariables.colorGreen,
                      text: "PROCEED",
                      onPressed: () {
                        if (carModelController.text.length < 3) {
                          showSnackBar("Please Provide a valid car model");
                          return;
                        }
                        if (carColourController.text.length < 3) {
                          showSnackBar("Please Provide a car colour");
                          return;
                        }
                        if (vehicleNumberController.text.length < 3) {
                          showSnackBar("Please Provide a valid vehicle number");
                          return;
                        }

                        updateProfile(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
