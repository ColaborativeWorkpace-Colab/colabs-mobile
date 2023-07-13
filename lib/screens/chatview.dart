import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:colabs_mobile/components/attachement_viewer.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/models/user.dart';
import 'package:colabs_mobile/utils/send_private_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  final Chat chat;
  final User? user;
  final TextEditingController messageController = TextEditingController();
  ChatView({super.key, required this.chat, this.user});

  @override
  Widget build(BuildContext context) {
    Authenticator authenticator = Provider.of<Authenticator>(context);
    LayoutController layoutController = Provider.of<LayoutController>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[200]!,
        appBar: AppBar(
            title: Row(children: <Widget>[
              const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black,
                              backgroundImage:  AssetImage(
                                      'assets/images/profile_placeholder.png')),
              const SizedBox(width: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth * .5,
                      child: Text(
                        (user != null) ? user!.userName ?? '' : '',
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                        (user != null)
                            ? user!.lastSeen.toString()
                            : 'Last Seen Recently',
                        style: const TextStyle(fontSize: 12))
                  ])
            ]),
            actions: <Widget>[
              PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (String value) {
                    //TODO: Report spam
                    //TODO: Block
                    //TODO: Add members
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                            value: 'Add Members',
                            child: ListTile(title: Text('Add Members'))),
                        const PopupMenuItem<String>(
                            value: 'Report Spam',
                            child: ListTile(title: Text('Report Spam'))),
                        const PopupMenuItem<String>(
                            value: 'Block',
                            child: ListTile(title: Text('Block')))
                      ])
            ]),
        body: Stack(children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.only(bottom: 50),
              width: screenWidth,
              height: screenHeight * .9,
              child: SingleChildScrollView(
                  controller: chat.messages.isNotEmpty
                      ? ScrollController(
                          initialScrollOffset: chat.messages.length * 5.5)
                      : null,
                  child: Column(children: <Widget>[
                    ...chat.messages.map((Message message) {
                      if (!message.messageText.contains('job_completed')) {
                        return BubbleNormal(
                            textStyle: TextStyle(
                                fontSize: 16,
                                color:
                                    message.senderId == authenticator.getUserId
                                        ? Colors.black87
                                        : Colors.white),
                            color: message.senderId == authenticator.getUserId
                                ? Colors.white
                                : const Color(0xFF5521B5),
                            text: message.messageText,
                            // ignore: always_specify_types
                            isSender:
                                message.senderId == authenticator.getUserId);
                      } else {
                        List<String> messageData =
                            message.messageText.split(':')[1].split(',');

                        return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xFF5521B5),
                                borderRadius: BorderRadius.circular(20)),
                            // ignore: always_specify_types
                            child: Column(children: [
                              ListTile(
                                  leading: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white),
                                  title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${messageData[1]} completed. Pay the workers to have full access of the project files.')),
                                  subtitle: Row(children: <Widget>[
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        child: const Text('Pay Salary',
                                            style: TextStyle(
                                                color: Color(0xFF5521B5))),
                                        onPressed: () {
                                          //TODO: Differentiate between recruiter and worker
                                          //TODO: Get project info
                                          //TODO: if paid, disable button
                                          //TODO: Open up chapa
                                        }),
                                    ElevatedButton(
                                        child: const Text('View Files'),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Column(
                                                    children: const <Widget>[
                                                      //TODO: Get project files
                                                      //TODO: Only download when job is paid
                                                    ]);
                                              });
                                        })
                                  ]))
                            ]));
                      }
                    })
                  ]))),
          Positioned(
              bottom: 1,
              child: Container(
                  color: Colors.grey[200]!,
                  child: Row(children: <Widget>[
                    Container(
                        height: 50,
                        width: screenWidth * .75,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                                        onPressed: () {
                                          sendPrivateMessage(context, chat,
                                              messageController:
                                                  messageController);
                                          layoutController.refresh(true);
                                        }
                                        //TODO: Add attachements variable
                                        //TODO: Send also for group chats
                                        ))))),
                    SizedBox(
                        width: 60,
                        child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AttachementViewer();
                                  });
                            },
                            child: const Icon(Icons.attachment_rounded)))
                  ])))
        ]));
  }
}
