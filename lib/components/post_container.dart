import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/components/share_container.dart';
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
          const SizedBox(height: 30),
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
                    onPressed: () => restService.likePostRequest(post.postId),
                    child: const Icon(Icons.thumb_up_alt_rounded,
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
                            //TODO: Get post link for sharing
                            return const ShareContainer(postLink: '');
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
                            return const ConnectionsGridView(
                                layoutOption: ConnectionsLayoutOptions.send);
                          });
                    },
                    child: const Icon(Icons.send, color: Color(0xFF5521B5))))
          ])
        ]));
  }
}
