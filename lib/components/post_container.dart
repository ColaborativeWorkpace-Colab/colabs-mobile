import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/components/share_container.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:colabs_mobile/screens/comments.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostContainer extends StatelessWidget {
  final Post post;
  const PostContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    RESTService restService = Provider.of<RESTService>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);
    LayoutController layoutController = Provider.of<LayoutController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        width: screenWidth * .95,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(10),
                      child: const CircleAvatar(
                          radius: 25, backgroundColor: Colors.black)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(post.postOwnerId,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        //TODO: Get User occupation
                        Text(post.postOwnerId,
                            style: const TextStyle(fontSize: 10)),
                        Text(post.timeStamp.toString(),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 10))
                      ])
                ]),
                (post.isDonatable)
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            child: const Text('Donate')))
                    : const SizedBox()
              ]),
          Container(
              margin: const EdgeInsets.all(10), child: Text(post.textContent)),
          Image(
              fit: BoxFit.cover,
              height: screenHeight * .4,
              image: const AssetImage('assets/images/placeholder.png')),
          Container(
              margin: const EdgeInsets.all(10),
              height: 20,
              child: Text(
                  '${post.likes.length} Likes  ${post.comments.length} Comments')),
          post.tags.isNotEmpty
              ? Row(children: <Widget>[
                  ...post.tags.map<Widget>((String tag) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                          child: Text(tag,
                              style: const TextStyle(color: Colors.blue)),
                          onTap: () {
                            //TODO: Explore Topic
                          })))
                ])
              : const SizedBox(),
          Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(
                  height: 1, thickness: 1, color: Color(0xFF5521B5))),
          Row(children: <Widget>[
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]!),
                    //TODO: Unlike post
                    onPressed: () {
                      restService
                          .likePostRequest(post.postId)
                          .then((bool requestSuccessful) {
                        if (requestSuccessful) {
                          post.likes.contains(authenticator.getUserId)
                              ? post.likes.remove(authenticator.getUserId)
                              : post.likes.add(authenticator.getUserId);
                          layoutController.refresh(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Request Failed')));
                        }
                      });
                    },
                    child: post.likes.contains(authenticator.getUserId)
                        ? const Icon(Icons.thumb_up_alt_rounded,
                            color: Color(0xFF5521B5))
                        : const Icon(Icons.thumb_up_alt_outlined,
                            color: Color(0xFF5521B5)))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]!),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<Comments>(
                              builder: (BuildContext context) =>
                                  Comments(post: post)));
                    },
                    child:
                        const Icon(Icons.comment, color: Color(0xFF5521B5)))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]!),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ShareContainer(postId: post.postId);
                          });
                    },
                    child: const Icon(Icons.share, color: Color(0xFF5521B5)))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]!),
                    onPressed: () {
                      //TODO: Send a post in private message
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ConnectionsGridView(
                                layoutOption: ConnectionsLayoutOptions.send, shareLink: Uri.http(restService.urlHost, '/share/${post.postId}').toString());
                          });
                    },
                    child: const Icon(Icons.send, color: Color(0xFF5521B5))))
          ])
        ]));
  }
}
