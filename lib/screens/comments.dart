import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/post.dart';
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
          //TODO: Display comments 
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
                                })
                          )))))
        ]));
  }
}
