import 'dart:convert';

import "package:http/http.dart" as http;

class RequestHelpers {
  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response res = await http.get(url);
      if (res.statusCode == 200) {
        String data = res.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return "failed";
      }
    } catch (err) {
      return "failed";
    }
  }
}
