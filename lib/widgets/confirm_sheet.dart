import 'package:car_driver_app/universal_variables.dart';
import "package:flutter/material.dart";
import 'package:car_driver_app/widgets/TaxiOutlineButton.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;

  ConfirmSheet({this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: 220,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Bolt-Semibold",
                color: UniversalVariables.colorText,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UniversalVariables.colorTextLight,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: "BACK",
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: "CONFIRM",
                      color: UniversalVariables.colorGreen,
                      onPressed: onPressed,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
