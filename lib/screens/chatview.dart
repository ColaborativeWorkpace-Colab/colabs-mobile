import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  final Chat chat;
  final TextEditingController messageController = TextEditingController();
  ChatView({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Provider.of<ChatController>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);
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
                  children: <Widget>[
                    Text(chat.receiver),
                    const SizedBox(height: 5),
                    //TODO: get last seen status
                    const Text('Last seen', style: TextStyle(fontSize: 12))
                  ])
            ]),
            actions: <Widget>[
              PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (String value) {
                    //TODO: Report spam
                    //TODO: Block
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                            value: 'Report Spam',
                            child: ListTile(title: Text('Report Spam'))),
                        const PopupMenuItem<String>(
                            value: 'Block',
                            child: ListTile(title: Text('Block')))
                      ])
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
                                    icon: const Icon(Icons.send),
                                    onPressed: () =>
                                        // ignore: always_specify_types
                                        chatController.sendPrivateMessage({
                                          'senderId': authenticator.getUserId,
                                          'receiverId': chat.receiver,
                                          'message': messageController.text,
                                          //TODO: Get chat id on initial text sent
                                          //TODO: Generate Timestamp
                                          'chatId': null
                                        })))))),
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
                      child: const Icon(Icons.attachment_rounded))
                )
              ]))
        ]));
  }
}
