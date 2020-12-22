import 'package:car_driver_app/screens/home_screen.dart';
import 'package:car_driver_app/screens/signup_screen.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/progress_dialog.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(barrierDismissible: false ,context: context, builder: (BuildContext context) => ProgressDialog(status: "Loggin You In"));
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).catchError((err) {
      Navigator.of(context).pop();
      PlatformException exception = err;
      showSnackBar(exception.message);
    })).user;

    if(user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child("users/${user.uid}");
      userRef.once().then((DataSnapshot snapshot) {
        if(snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
        }
      });
    }
  }

  void showSnackBar(String title) {
    final snackBar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15)));
    scaffoldKey.currentState.showSnackBar(snackBar);
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
                  "Login As Driver",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: "Nunito-Bold"),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
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
                        controller: passwordController,
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
                        text: "LOGIN",
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar("No Internet Connection");
                            return;
                          }
                          loginUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, SignUpScreen.id, (route) => false),
                    child: Text("Don't have an account? Sign Up"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
