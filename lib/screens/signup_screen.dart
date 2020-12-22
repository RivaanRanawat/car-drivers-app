import 'package:car_driver_app/screens/home_screen.dart';
import 'package:car_driver_app/screens/login_screen.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/progress_dialog.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "signup";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var nameEditingController = TextEditingController();

  var emailEditingController = TextEditingController();

  var phoneEditingController = TextEditingController();

  var passwordEditingController = TextEditingController();

  void showSnackBar(String title) {
    final snackBar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15)));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void signUpUser() async {
    showDialog(barrierDismissible: false ,context: context, builder: (BuildContext context) => ProgressDialog(status: "Registering you..."));
    final FirebaseUser user =
        (await _firebaseAuth.createUserWithEmailAndPassword(
                email: emailEditingController.text,
                password: passwordEditingController.text).catchError((err) {
                  Navigator.of(context).pop();
                  PlatformException exception = err;
                  showSnackBar(exception.message);
                }))
            .user;
    Navigator.of(context).pop();
    if (user != null) {
      DatabaseReference reference = FirebaseDatabase.instance.reference().child("drivers/${user.uid}");
      Map userMap = {
        "fullName" : nameEditingController.text.trim(),
        "email": emailEditingController.text.trim(),
        "phone": phoneEditingController.text.trim(),
      };

      reference.set(userMap);
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 210,
                ),
                Text(
                  "Create Driver's Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: "Nunito-Bold"),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameEditingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: phoneEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordEditingController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                        obscureText: true,
                      ),
                      SizedBox(height: 40),
                      ReusableButton(
                        color: UniversalVariables.colorAccentPurple,
                        text: "SIGN UP",
                        onPressed: () async {
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar("No Internet Connection");
                            return;
                          }
                          if (nameEditingController.text.length < 7) {
                            showSnackBar("Please Provide Your Full Name");
                            return;
                          }
                          if (phoneEditingController.text.length < 10) {
                            showSnackBar("Please Provide a valid number");
                            return;
                          }
                          if (!emailEditingController.text.contains("@")) {
                            showSnackBar("Please Provide a valid email");
                            return;
                          }

                          var password = passwordEditingController.text;
                          bool hasUppercase =
                              password.contains(new RegExp(r'[A-Z]'));
                          bool hasDigits =
                              password.contains(new RegExp(r'[0-9]'));
                          bool hasLowercase =
                              password.contains(new RegExp(r'[a-z]'));
                          bool hasSpecialCharacters = password
                              .contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                          bool hasMinLength = password.length > 8;

                          if(hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength == false) {
                            showSnackBar("Password must contain uppercase, lowercase, special characters and digits");
                            return;
                          }
                          signUpUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.id, (route) => false),
                    child: Text("Already have an account? Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
