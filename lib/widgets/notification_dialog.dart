import 'package:car_driver_app/models/tripDetails.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/TaxiOutlineButton.dart';
import 'package:car_driver_app/widgets/reusable_divider.dart';
import "package:flutter/material.dart";

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;
  NotificationDialog(this.tripDetails);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset("assets/images/taxi.png", width: 100),
            SizedBox(
              height: 16,
            ),
            Text(
              "NEW TRIP REQUEST",
              style: TextStyle(fontFamily: "Bolt-Semibold", fontSize: 18),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/pickicon.png",
                          height: 16, width: 16),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Text(
                          tripDetails.pickupAddress,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/desticon.png",
                          height: 16, width: 16),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Text(
                          tripDetails.destinationAddress,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ReusableDivider(),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: "DECLINE",
                        color: UniversalVariables.colorPrimary,
                        onPressed: () async {},
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: "ACCEPT",
                        color: UniversalVariables.colorGreen,
                        onPressed: () async {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
