import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:colabs_mobile/models/post_comment.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    RESTService restService = Provider.of<RESTService>(context);
    LayoutController layoutController = Provider.of<LayoutController>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        appBar: AppBar(title: const Text('Comments')),
        body: SizedBox(
          height: screenHeight,
          child: Stack(children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 50.0,
                    right: 16.0,
                    left: 16.0,
                    top: 16.0,
                  ),
                  child: CommentTreeWidget<Comment, Comment>(
                      Comment(
                          content: post.textContent,
                          avatar: null,
                          userName: post.postOwnerId),
                      <Comment>[
                        ...post.comments.map<Comment>((PostComment comment) =>
                            Comment(
                                avatar: null,
                                userName: comment.userId,
                                content: comment.comment))
                      ],
                      treeThemeData: const TreeThemeData(lineWidth: 1),
                      avatarRoot: (BuildContext context, Comment data) =>
                          const PreferredSize(
                              preferredSize: Size(50, 50),
                              child: CircleAvatar()),
                      avatarChild: (BuildContext context, Comment data) =>
                          const PreferredSize(
                              preferredSize: Size(50, 50),
                              child: CircleAvatar()),
                      contentChild: (BuildContext context, Comment data) {
                        return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: ListTile(
                                title: Text(data.userName!),
                                subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.content!))));
                      },
                      contentRoot: (BuildContext context, Comment data) {
                        return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: ListTile(
                                title: Text(data.userName!),
                                subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //TODO: Load images
                                          Image(
                                              image: post.imageContentUrl
                                                      .isNotEmpty
                                                  ? Image.network(
                                                          post.imageContentUrl)
                                                      .image
                                                  : const AssetImage(
                                                      'assets/images/placeholder.png')),
                                          const SizedBox(height: 10),
                                          Text(data.content!)
                                        ]))));
                      })),
            ),
            Positioned(
                bottom: -1,
                child: Container(
                    color: const Color.fromARGB(255, 238, 238, 238),
                    child: Container(
                        height: 50,
                        width: screenWidth * .95,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                                          restService
                                              .commentPostRequest(post.postId,
                                                  commentController.text)
                                              .then((bool requestSuccessful) {
                                            if (requestSuccessful) {
                                              post.comments.add(PostComment(
                                                  authenticator.getUserId!,
                                                  commentController.text));
                                              layoutController.refresh(true);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Request Failed')));
                                            }
                                          });
                                        })))))))
          ]),
        ));
  }
}
