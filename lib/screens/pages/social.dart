import 'package:colabs_mobile/components/feed.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/types/search_filters.dart';
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
              (restService.getSocialFeedPosts.isNotEmpty ||
                      restService.isPosting)
                  ? const Feed(isExploring: false)
                  : Container(
                      margin: EdgeInsets.only(top: screenHeight * .25),
                      child: SizedBox(
                          width: screenWidth * .7,
                          child: Column(children: <Widget>[
                            const Icon(Icons.photo_rounded,
                                color: Colors.grey, size: 80),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text(
                                '''Your social feed is empty.''',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  restService.isRefreshing = true;
                                  restService
                                      .getSocialFeedRequest()
                                      .timeout(const Duration(seconds: 10),
                                          onTimeout: () =>
                                              restService.isRefreshing = false)
                                      .then((bool value) {
                                    restService.isRefreshing = false;
                                  });
                                },
                                child: (!restService.isRefreshing)
                                    ? const Icon(Icons.refresh)
                                    : const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      ))
                          ])))
            ])));
  }
}
