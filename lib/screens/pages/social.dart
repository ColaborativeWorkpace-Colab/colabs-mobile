import 'package:colabs_mobile/components/post_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatelessWidget {
  SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey[200]!,
        child: Column(
          children: <Widget>[
            const Navbar(searchFilter: SearchFilter.social),
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
