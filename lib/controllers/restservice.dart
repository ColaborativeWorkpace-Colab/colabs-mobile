import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RESTService extends ChangeNotifier {
  final String urlHost = dotenv.env['DEV_URL']!;
  Authenticator? authenticator;

  RESTService();

  Future<bool> getSocialFeed() async {
    try {
      http.Response response = await http.get(
          Uri.http(urlHost, '/api/v1/profile/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        notifyListeners();
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  set setAuthenticator(Authenticator value) {
    authenticator = value;
  }
}
