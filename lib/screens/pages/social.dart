import 'package:colabs_mobile/components/post_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

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
                  padding: const EdgeInsets.only(bottom: 95),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return const PostContainer();
                  }),
            )
          ]
        )
      )
    );
  }
}
