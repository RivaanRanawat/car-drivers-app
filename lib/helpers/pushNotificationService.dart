import 'package:car_driver_app/universal_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize() async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print("token: $token");
    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child("drivers/${currentFirebaseUser.uid}/$token");
    tokenRef.set(token);

    fcm.subscribeToTopic("allDrivers");
    fcm.subscribeToTopic("allUsers");
  }
}