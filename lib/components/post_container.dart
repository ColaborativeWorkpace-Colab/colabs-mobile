import 'package:colabs_mobile/models/post.dart';
import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  final Post post;
  const PostContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        height: screenHeight * .62,
        width: screenWidth * .95,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Container(
                margin: const EdgeInsets.all(10),
                child: const CircleAvatar(
                    radius: 25, backgroundColor: Colors.black)),
            Column(children: <Widget>[
              Text(post.postOwnerId,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  //TODO: Get User occupation
              Text(post.postOwnerId, style: const TextStyle(fontSize: 10)),
              Text(post.timeStamp.toString(),
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 10))
            ])
          ]),
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
                    onPressed: () {
                      //TODO: Like a post
                    },
                    child: const Icon(
                      Icons.thumb_up_alt_rounded,
                      color: Color(0xFF5521B5),
                    ))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]!),
                    onPressed: () {
                      //TODO: Comment on a post
                      Navigator.pushNamed(context, '/comments');
                    },
                    child: const Icon(
                      Icons.comment,
                      color: Color(0xFF5521B5),
                    ))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]!),
                    onPressed: () {
                      //TODO: share a post
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(height: screenHeight * .5);
                          });
                    },
                    child: const Icon(
                      Icons.share,
                      color: Color(0xFF5521B5),
                    ))),
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
                            return Container(height: screenHeight * .5);
                          });
                    },
                    child: const Icon(
                      Icons.send,
                      color: Color(0xFF5521B5),
                    )))
          ])
        ]));
  }
}
