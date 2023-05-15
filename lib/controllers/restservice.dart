import 'dart:convert';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RESTService extends ChangeNotifier {
  final String urlHost = dotenv.env['DEV_URL']!;
  Authenticator? authenticator;
  final List<String> _userConnections = <String>[
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g'
  ];
  final List<Post> _socialFeedPosts = <Post>[];

  RESTService();

  Future<bool> getSocialFeed() async {
    try {
      http.Response response = await http
          .get(Uri.http(urlHost, '/api/v1/social/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        _populateSocialFeed(response.body);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _populateSocialFeed(String body) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    List<dynamic> rawPosts = decodedJsonBody['posts'];

    for (Map<String, dynamic> rawPost in rawPosts) {
      if (!_postExists(rawPost['_id']))
        // ignore: curly_braces_in_flow_control_structures
        _socialFeedPosts.add(Post(
            rawPost['_id'],
            rawPost['userId'],
            rawPost['textContent'],
            rawPost['imageContent'],
            DateTime.parse(rawPost['createdAt']),
            rawPost['tags'],
            rawPost['likes'],
            rawPost['comments']));
    }
  }

  bool _postExists(String postId) {
    for (Post post in _socialFeedPosts) {
      if (post.postId == postId) return true;
    }

    return false;
  }

  Future<bool> postContentRequest(Map<String, dynamic> body) async {
    try {
      http.Response response = await http.post(
          Uri.http(urlHost, '/api/v1/social/${authenticator!.getUserId}'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(body));

      if (response.statusCode == 200)
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(true);
      else
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(false);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> likePostRequest(String postId) async {
    try {
      http.Response response = await http.put(Uri.http(
          urlHost, '/api/v1/social/${authenticator!.getUserId}/$postId/like'));

      if (response.statusCode == 200)
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(true);
      else
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(false);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> commentPostRequest(String postId, String comment) async {
    try {
      http.Response response = await http.put(Uri.http(
          urlHost, '/api/v1/social/${authenticator!.getUserId}/$postId/comment'), 
          headers: <String, String>{'Content-Type': 'application/json'},
          // ignore: always_specify_types
          body: json.encode({'comment': comment}));

      if (response.statusCode == 200)
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(true);
      else
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(false);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  set setAuthenticator(Authenticator value) {
    authenticator = value;
  }

  List<String> get getUserConnections => _userConnections;
  List<Post> get getSocialFeedPosts => _socialFeedPosts;
}
