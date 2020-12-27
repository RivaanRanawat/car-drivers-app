import 'package:car_driver_app/helpers/helperRepository.dart';
import 'package:car_driver_app/universal_variables.dart';
import 'package:car_driver_app/widgets/reusable_button.dart';
import 'package:car_driver_app/widgets/reusable_divider.dart';
import 'package:flutter/material.dart';


class CollectPaymentDialog extends StatelessWidget {

  final String paymentMethod;
  final int fares;

  CollectPaymentDialog({this.paymentMethod, this.fares});
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(height: 20,),

            Text('${paymentMethod.toUpperCase()} PAYMENT'),

            SizedBox(height: 20,),

            ReusableDivider(),

            SizedBox(height: 16.0,),

            Text('\₹$fares', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),),

            SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Amount above is the total fares to be charged to the rider', textAlign: TextAlign.center,),
            ),

            SizedBox(height: 30,),

            Container(
              width: 230,
              child: ReusableButton(
                text: (paymentMethod == 'cash') ? 'COLLECT CASH' : 'CONFIRM',
                color: UniversalVariables.colorGreen,
                onPressed: (){

                  Navigator.pop(context);
                  Navigator.pop(context);

                  HelperRepository.enableHomeTabLocationUpdates();

                },
              ),
            ),

            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}