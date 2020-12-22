import 'package:car_driver_app/universal_variables.dart';
import "package:flutter/material.dart";

class ReusableButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;
  ReusableButton({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25),
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Nunito-Bold",
            ),
          ),
        ),
      ),
    );
  }
}
