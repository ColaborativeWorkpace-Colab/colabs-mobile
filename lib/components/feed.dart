import 'package:colabs_mobile/components/post_container.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  final List<Post>? posts;
  final bool isExploring;
  const Feed({super.key, required this.isExploring, this.posts});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    RESTService restService = Provider.of<RESTService>(context);

    return Expanded(
        child: RefreshIndicator(
            onRefresh: () => isExploring
                ? restService.getPostData()
                : restService.getSocialFeedRequest(),
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 95),
                shrinkWrap: true,
                itemCount: isExploring ? posts!.length : (!restService.isPosting)
                    ? restService.getSocialFeedPosts.length
                    : restService.getSocialFeedPosts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return (restService.isPosting && index == 0)
                      ? Container(
                          width: screenWidth * .95,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 10),
                                    blurRadius: 5)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child:
                              const Center(child: CircularProgressIndicator()))
                      : PostContainer(
                          post: isExploring ? posts![index] : restService.getSocialFeedPosts[index]);
                })));
  }
}
