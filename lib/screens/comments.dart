import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Comments extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();
  final Post post;
  Comments({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    RESTService restService = Provider.of<RESTService>(context);

    return Scaffold(
        appBar: AppBar(title: const Text('Comments')),
        body: Stack(children: <Widget>[
          //TODO: Populate comments
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CommentTreeWidget<Comment, Comment>(
                Comment(
                    content: post.textContent,
                    avatar: 'Avatar',
                    userName: post.postOwnerId),
                // ignore: always_specify_types
                <Comment>[...post.comments.map<Comment>((rawComment) => Comment(
                  avatar: 'Avatar',
                  //TODO: Get user names
                  userName: 'Other user',
                  content: 'Their comment'
                ))],
                treeThemeData:
                    const TreeThemeData(lineWidth: 3),
                avatarRoot: (BuildContext context, Comment data) =>
                    const PreferredSize(
                        preferredSize: Size(50, 50), child: CircleAvatar()),
                avatarChild: (BuildContext context, Comment data) =>
                    const PreferredSize(
                        preferredSize: Size(50, 50), child: CircleAvatar()),
                contentChild: (BuildContext context, Comment data) {
                  return const SizedBox();
                },
                contentRoot: (BuildContext context, Comment data) {
                  return const SizedBox();
                })
          ),
          Positioned(
              bottom: 1,
              child: Container(
                  height: 50,
                  width: screenWidth * .95,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          suffixIcon: Container(
                              margin: const EdgeInsets.only(top: 0),
                              child: IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    restService.commentPostRequest(
                                        post.postId, commentController.text);
                                  }))))))
        ]));
  }
}
