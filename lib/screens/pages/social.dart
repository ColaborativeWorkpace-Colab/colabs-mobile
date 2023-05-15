import 'package:colabs_mobile/components/post_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    RESTService restService = Provider.of<RESTService>(context);
    
    return SafeArea(
        child: Container(
            color: Colors.grey[200]!,
            child: Column(children: <Widget>[
              const Navbar(searchFilter: SearchFilter.social),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 95),
                    shrinkWrap: true,
                    itemCount: restService.getSocialFeedPosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostContainer(post: restService.getSocialFeedPosts[index]);
                    })
              )
            ])));
  }
}
