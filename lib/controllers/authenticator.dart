import 'package:colabs_mobile/types/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';

class Authenticator extends ChangeNotifier {
  final bool _isAuthorized = false;
  final GitHubOAuth2Client githubClient = GitHubOAuth2Client(
      redirectUri: dotenv.env['GITHUB_CALLBACK_URL']!,
      customUriScheme: 'http');
  final GoogleOAuth2Client googleClient = GoogleOAuth2Client(
      redirectUri: dotenv.env['GOOGLE_CALLBACK_URL']!,
      customUriScheme: 'http');
  AccessTokenResponse? _accessToken;
  bool _hasUserAgreed = false;
  UserType _selectedUserType = UserType.freelancer;
  //TODO: Get UserId
  final String? _userId = '64344fc7fe1d1fa62a1fc423';

  //TODO: Get valid github scope
  Future<AccessTokenResponse> getGithubToken() async {
    return githubClient.getTokenWithAuthCodeFlow(
        clientId: dotenv.env['GITHUB_CLIENT_ID']!,
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
        scopes: <String>['repo']);
  }

  Future<AccessTokenResponse> getGoogleToken() async {
    return googleClient.getTokenWithAuthCodeFlow(
        clientId: dotenv.env['GOOGLE_CLIENT_ID']!,
        clientSecret: dotenv.env['GOOGLE_CLIENT_SECRET']!,
        scopes: <String>['profile']);
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

  AccessTokenResponse? get getAccessToken => _accessToken;
  bool get isUserAuthorized => _isAuthorized;
  bool get hasUserAgreed => _hasUserAgreed;
  UserType get getUserType => _selectedUserType;
  String? get getUserId => _userId;
}
