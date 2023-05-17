import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/screens/chatview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void tagUserConnection(BuildContext context, int index) {
  RESTService restService = Provider.of<RESTService>(context);
  ContentController contentController = Provider.of<ContentController>(context);

  (!contentController.getTaggedUsers
          .contains(restService.getUserConnections[index]))
      ? contentController.tagUser(restService.getUserConnections[index])
      : contentController.untagUser(restService.getUserConnections[index]);
}

Widget toggleTaggedMark(BuildContext context, int index) {
  ContentController contentController = Provider.of<ContentController>(context);
  RESTService restService = Provider.of<RESTService>(context);

  return (contentController.getTaggedUsers
          .contains(restService.getUserConnections[index]))
      ? const Positioned(
          bottom: 1,
          right: 5,
          child: Icon(Icons.check_circle, color: Colors.indigoAccent),
        )
      : const SizedBox();
}

void chatWithConnection(BuildContext context, String receiverId) {
  ChatController chatController = Provider.of<ChatController>(context, listen:false);
  Chat newChat = Chat(receiverId, <Message>[]);

  for (Chat chat in chatController.getChats) {
    if (chat.receiver == receiverId) {
      Navigator.push(
          context,
          MaterialPageRoute<ChatView>(
              builder: (BuildContext context) => ChatView(chat: chat)));
      return;
    }
  }

  Navigator.push(
      context,
      MaterialPageRoute<ChatView>(
          builder: (BuildContext context) => ChatView(chat: newChat)));
}
