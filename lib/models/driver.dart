import 'package:firebase_database/firebase_database.dart';

class Driver {
  String fullName;
  String email;
  String phone;
  String id;
  String carModel;
  String carColour;
  String vehicleNumber;

  Driver({this.carColour, this.carModel, this.email, this.fullName, this.id, this.phone, this.vehicleNumber});
  Driver.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value["phone"];
    email = snapshot.value["email"];
    fullName = snapshot.value["fullName"];
    carModel = snapshot.value["vehicle_details"]["car_model"];
    carColour = snapshot.value["vehicle_details"]["car_colour"];
    vehicleNumber = snapshot.value["vehicle_details"]["vehicle_number"];
  }
}