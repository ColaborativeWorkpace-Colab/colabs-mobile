import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:colabs_mobile/types/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Authenticator extends ChangeNotifier {
  final String urlHost = dotenv.env['DEV_URL']!;
  final GitHubOAuth2Client githubClient = GitHubOAuth2Client(
      redirectUri: dotenv.env['GITHUB_CALLBACK_URL']!, customUriScheme: 'http');

  final GoogleOAuth2Client googleClient = GoogleOAuth2Client(
      redirectUri: dotenv.env['GOOGLE_CALLBACK_URL']!, customUriScheme: 'http');

  Authenticator() {
    _getPref();
  }

  Auth0 auth0 = Auth0(
      'dev-2v754txtnd1f4zcy.us.auth0.com', 'gZEsWQ3VcaTMNpPmBVbxX4oqaRv9szCt');
  AccessTokenResponse? _accessToken;
  bool _hasUserAgreed = false;
  bool _isAuthorized = false;
  UserType _selectedUserType = UserType.freelancer;
  //TODO: Get UserId
  String? _userId;
  String? _token;

  //TODO: Get valid github scope
  Future<void> getGithubToken() async {
    Credentials credentials = await auth0.webAuthentication().login(
        redirectUrl:
            "colabs.mobile://dev-2v754txtnd1f4zcy.us.auth0.com/android/com.example.colabs_mobile/callback");

    // return githubClient.getTokenWithAuthCodeFlow(
    //     clientId: dotenv.env['GITHUB_CLIENT_ID']!,
    //     clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
    //     scopes: <String>['repo']);
  }

  Future<AccessTokenResponse> getGoogleToken() async {
    return googleClient.getTokenWithAuthCodeFlow(
        clientId: dotenv.env['GOOGLE_CLIENT_ID']!,
        clientSecret: dotenv.env['GOOGLE_CLIENT_SECRET']!,
        scopes: <String>['profile'],
        afterAuthorizationCodeCb: () {});
  }

  Future<bool> login(Map<String, dynamic> body) async {
    http.Response response = await http.post(
        Uri.http(urlHost, '/api/v1/users/login'),
        body: json.encode(body),
        headers: <String, String>{'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);

      _token = body['token'];
      // ignore: avoid_dynamic_calls
      _userId = body['data']['_id'];
      await setPref(<String, dynamic>{'token': _token, 'userId': _userId});
      notifyListeners();
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  Future<void> _getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    _token = pref.getString("token");
    _userId = pref.getString("userId");

    notifyListeners();
  }

  Future<bool> setPref(Map<String, dynamic> authInfo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString('token', authInfo['token']);
    await pref.setString('userId', authInfo['userId']);

    notifyListeners();
    return Future<bool>.value(true);
  }

  Future<bool> register(Map<String, dynamic> body, String userType) async {
    http.Response response = await http.post(
        Uri.http(urlHost, '/api/v1/users',
            <String, dynamic>{'type': userType, 'isMobile': 'true'}),
        body: json.encode(body),
        headers: <String, String>{'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print(response.body);
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  set setAccessToken(AccessTokenResponse value) {
    _accessToken = value;
    notifyListeners();
  }

  set setHasUserAgreed(bool value) {
    _hasUserAgreed = value;
    notifyListeners();
  }

  set setUserType(UserType value) {
    _selectedUserType = value;
    notifyListeners();
  }

  set setIsAuthorized(bool value) {
    _isAuthorized = value;
  }

  AccessTokenResponse? get getAccessToken => _accessToken;
  bool get isUserAuthorized => _isAuthorized;
  bool get hasUserAgreed => _hasUserAgreed;
  UserType get getUserType => _selectedUserType;
  String? get getUserId => _userId;
  String? get getToken => _token;
}
