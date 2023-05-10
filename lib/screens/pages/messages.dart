import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/screens/chatview.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.message),
      Container(
          margin: const EdgeInsets.only(top: 5),
          height: screenHeight * .8,
          child: Stack(children: <Widget>[
            ListView.builder(
                //TODO: add placeholder screen for when there is no chats
                padding: const EdgeInsets.only(bottom: 95),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                      child: ListTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 0.5)),
                          leading: const CircleAvatar(radius: 27),
                          title: const Text('User'),
                          subtitle: const Text('Last Message'),
                          trailing: Column(children: <Widget>[
                            //TODO: Add message info
                            const SizedBox(height: 10),
                            const Text('9:58 PM'),
                            Icon((index % 2 == 0) ? Icons.done : Icons.done_all)
                          ]),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<Widget>(
                                    builder: (BuildContext context) =>
                                        ChatView(chatId: 'dummy')));
                          }));
                }),
            Positioned(
                top: screenHeight * .62,
                right: 10,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20)),
                      child: const Icon(Icons.edit),
                    )))
          ]))
    ]));
  }
}
