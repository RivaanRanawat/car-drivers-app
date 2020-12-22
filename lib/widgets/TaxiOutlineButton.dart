import 'package:flutter/material.dart';
import 'package:car_driver_app/universal_variables.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;

  TaxiOutlineButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25.0),
        ),
        onPressed: onPressed,
        color: color,
        textColor: color,
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Brand-Bold',
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
