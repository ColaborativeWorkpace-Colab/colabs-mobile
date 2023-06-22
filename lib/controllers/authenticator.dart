import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:colabs_mobile/types/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class Authenticator extends ChangeNotifier {
  final GitHubOAuth2Client githubClient = GitHubOAuth2Client(
      redirectUri: dotenv.env['GITHUB_CALLBACK_URL']!, customUriScheme: 'http');

  final GoogleOAuth2Client googleClient = GoogleOAuth2Client(
      redirectUri: dotenv.env['GOOGLE_CALLBACK_URL']!, customUriScheme: 'http');
  Auth0 auth0 = Auth0(
      'dev-2v754txtnd1f4zcy.us.auth0.com', 'gZEsWQ3VcaTMNpPmBVbxX4oqaRv9szCt');
  AccessTokenResponse? _accessToken;
  bool _hasUserAgreed = false;
  bool _isAuthorized = false;
  UserType _selectedUserType = UserType.freelancer;
  //TODO: Get UserId
  final String _userId = '6493f06af7663ee7c3c486e4';

  //TODO: Get valid github scope
  Future<void> getGithubToken() async {
    final Credentials credentials = await auth0.webAuthentication().login(
        redirectUrl:
            "colabs.mobile://dev-2v754txtnd1f4zcy.us.auth0.com/android/com.example.colabs_mobile/callback");
    print(credentials.user.customClaims);
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
}
