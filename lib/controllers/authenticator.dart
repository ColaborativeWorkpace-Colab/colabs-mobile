import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';

class Authenticator extends ChangeNotifier {
  final bool _isAuthorized = false;
  final GitHubOAuth2Client githubClient = GitHubOAuth2Client(
      redirectUri: dotenv.env['GITHUB_CALLBACK_URL']!, customUriScheme: 'http');
  final GoogleOAuth2Client googleClient = GoogleOAuth2Client(
      redirectUri: dotenv.env['GOOGLE_CALLBACK_URL']!, customUriScheme: 'http');
  AccessTokenResponse? _accessToken;

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
        scopes: <String>['repo']);
  }

  set setAccessToken(AccessTokenResponse value) {
    _accessToken = value;
    notifyListeners();
  }

  AccessTokenResponse? get getAccessToken => _accessToken;
  bool get isUserAuthorized => _isAuthorized;
}
