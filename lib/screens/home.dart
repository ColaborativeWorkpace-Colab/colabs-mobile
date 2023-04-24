import 'package:colabs_mobile/components/post_container.dart';
import 'package:colabs_mobile/components/social_navbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SocialNavbar(),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return const PostContainer();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
