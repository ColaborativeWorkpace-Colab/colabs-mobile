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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Container(
            color: Colors.grey[200]!,
            child: Column(children: <Widget>[
              const Navbar(searchFilter: SearchFilter.social),
              (restService.getSocialFeedPosts.isNotEmpty)
                  ? Expanded(
                      child: RefreshIndicator(
                          onRefresh: () => restService.getSocialFeed(),
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 95),
                              shrinkWrap: true,
                              itemCount: restService.getSocialFeedPosts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PostContainer(
                                    post:
                                        restService.getSocialFeedPosts[index]);
                              })))
                  : Container(
                      margin: EdgeInsets.only(top: screenHeight * .25),
                      child: SizedBox(
                          width: screenWidth * .7,
                          child: Column(children: const <Widget>[
                            Icon(Icons.photo_rounded,
                                color: Colors.grey, size: 80),
                            SizedBox(height: 20),
                            Text(
                              '''Your social feed is empty. Go to your profile and pick the topics that interest you.''',
                              textAlign: TextAlign.center,
                            )
                          ])))
            ])));
  }
}
