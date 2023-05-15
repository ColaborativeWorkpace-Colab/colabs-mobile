import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/screens/chatview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ChatController chatController = Provider.of<ChatController>(context);

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.message),
      Container(
          margin: const EdgeInsets.only(top: 5),
          height: screenHeight * .8,
          child: Stack(children: <Widget>[
            chatController.getChats.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.only(bottom: 95),
                    shrinkWrap: true,
                    itemCount: chatController.getChats.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<Message> messages = chatController
                          .getChats[index].messages.reversed
                          .toList();
                      return Material(
                          child: ListTile(
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey, width: 0.5)),
                              leading: const CircleAvatar(radius: 27),
                              title: Text(chatController.getChats[index].user),
                              subtitle: Text(messages[0].messageText),
                              trailing: Column(children: <Widget>[
                                const SizedBox(height: 10),
                                Text(messages[0].timeStamp.toString()),
                                Icon((messages[0].isRead)
                                    ? Icons.done
                                    : Icons.done_all)
                              ]),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<Widget>(
                                        builder: (BuildContext context) =>
                                            ChatView(
                                                chat: chatController
                                                    .getChats[index])));
                              }));
                    })
                : Positioned(
                    top: screenHeight * .25,
                    left: screenWidth * .15,
                    child: SizedBox(
                        width: screenWidth * .7,
                        child: Column(children: const <Widget>[
                          Icon(Icons.chat, color: Colors.grey, size: 80),
                          SizedBox(height: 20),
                          Text(
                            '''Chats are empty. Go ahead and say hi to one of your connections''',
                            textAlign: TextAlign.center,
                          )
                        ]))),
            Positioned(
                top: screenHeight * .62,
                right: 10,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return const ConnectionsGridView(
                                  title: 'Chat with...');
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20)),
                      child: const Icon(Icons.edit),
                    )))
          ]))
    ]));
  }
}
