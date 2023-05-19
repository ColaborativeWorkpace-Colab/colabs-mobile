import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/screens/chatview.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:colabs_mobile/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ChatController chatController = Provider.of<ChatController>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);
    RESTService restService = Provider.of<RESTService>(context);

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.message),
      Container(
          margin: const EdgeInsets.only(top: 5),
          height: screenHeight * .8,
          child: Stack(children: <Widget>[
            chatController.getChats.isNotEmpty
                ? RefreshIndicator(
                  onRefresh: () => restService.getMessages(listen: true),
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 95),
                      shrinkWrap: true,
                      itemCount: chatController.getChats.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<Message> messages = chatController
                            .getChats[index].messages.reversed
                            .toList();
                        return Material(
                            child: ListTile(
                                contentPadding: const EdgeInsets.all(5),
                                shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey, width: 0.5)),
                                leading: const CircleAvatar(radius: 27),
                                title: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                      chatController.getChats[index].receiver,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                subtitle: Text(messages[0].messageText,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontWeight: (messages[0].isRead)
                                            ? FontWeight.normal
                                            : FontWeight.bold)),
                                trailing: Column(children: <Widget>[
                                  const SizedBox(height: 10),
                                  Text(DateFormat(
                                          formatDate(messages[0].timeStamp))
                                      .format(messages[0].timeStamp)),
                                  (messages[0].senderId !=
                                          authenticator.getUserId)
                                      ? Icon((messages[0].isRead)
                                          ? Icons.done_all
                                          : Icons.done)
                                      : const SizedBox()
                                ]),
                                onTap: () {
                                  if (messages[0].senderId ==
                                      authenticator.getUserId) {
                                    chatController.markAsRead(
                                        chatController.getChats[index]);
                                    chatController.refresh();
                                  }
                
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<Widget>(
                                          builder: (BuildContext context) =>
                                              ChatView(
                                                  chat: chatController
                                                      .getChats[index])));
                                }));
                      }),
                )
                : Positioned(
                    top: screenHeight * .25,
                    left: screenWidth * .15,
                    child: SizedBox(
                        width: screenWidth * .7,
                        child: Column(children: <Widget>[
                          const Icon(Icons.chat, color: Colors.grey, size: 80),
                          const SizedBox(height: 20),
                          const Text(
                            '''Chats are empty. Go ahead and say hi to one of your connections''',
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                restService.isRefreshing = true;
                                restService
                                    .getMessages()
                                    .timeout(const Duration(seconds: 10),
                                        onTimeout: () =>
                                            restService.isRefreshing = false)
                                    .then((bool value) {
                                  restService.isRefreshing = false;
                                });
                              },
                              child: (!restService.isRefreshing)
                                  ? const Icon(Icons.refresh)
                                  : const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    ))
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
                                  layoutOption: ConnectionsLayoutOptions.chat);
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
