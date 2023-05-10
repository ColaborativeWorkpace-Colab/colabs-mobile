import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  final String chatId;
  final TextEditingController messageController = TextEditingController();
  ChatView({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.grey[200]!,
        appBar: AppBar(
            title: Row(children: <Widget>[
              const CircleAvatar(
                backgroundColor: Colors.black,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('User'),
                  SizedBox(height: 5),
                  Text('Last seen', style: TextStyle(fontSize: 12))
                ],
              )
            ]),
            actions: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ]),
        body: Stack(children: <Widget>[
          Positioned(
              bottom: 1,
              child: Row(children: <Widget>[
                Container(
                  height: 50,
                  width: screenWidth * .75,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(top: 0),
                            child: IconButton(
                                icon: const Icon(Icons.send), onPressed: () {}),
                          ))),
                ),
                SizedBox(
                  width: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 100,
                              );
                            });
                      },
                      child: const Icon(Icons.attachment_rounded)),
                )
              ]))
        ]));
  }
}
