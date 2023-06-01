import 'package:colabs_mobile/components/feed.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  final String? title;
  final List<Post> posts;
  const ExploreScreen({super.key, this.title, required this.posts});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(title: Text(title ?? 'Explore')),
        body: Column(
          children: <Widget>[
            Feed(isExploring: true, posts: posts),
          ],
        ));
  }
}
