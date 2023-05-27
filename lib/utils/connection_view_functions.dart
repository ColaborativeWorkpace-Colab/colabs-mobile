import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/models/user.dart';
import 'package:colabs_mobile/screens/chatview.dart';
import 'package:colabs_mobile/types/chat_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void tagUserConnection(BuildContext context, int index) {
  RESTService restService = Provider.of<RESTService>(context, listen: false);
  ContentController contentController =
      Provider.of<ContentController>(context, listen: false);

  (!contentController.getTaggedUsers
          .contains(restService.getUserConnections[index].userId))
      ? contentController.tagUser(restService.getUserConnections[index].userId)
      : contentController
          .untagUser(restService.getUserConnections[index].userId);
}

Widget toggleTaggedMark(BuildContext context, int index) {
  ContentController contentController = Provider.of<ContentController>(context);
  RESTService restService = Provider.of<RESTService>(context, listen: false);

  return (contentController.getTaggedUsers
          .contains(restService.getUserConnections[index].userId))
      ? const Positioned(
          bottom: 1,
          right: 5,
          child: Icon(Icons.check_circle, color: Colors.indigoAccent),
        )
      : const SizedBox();
}

void chatWithConnection(BuildContext context, String receiverId) {
  ChatController chatController =
      Provider.of<ChatController>(context, listen: false);
  RESTService restService = Provider.of<RESTService>(context);
  Chat newChat = Chat(receiverId, <Message>[], ChatType.private);
  User? user = restService.getUserInfo(receiverId);

  for (Chat chat in chatController.getChats) {
    if (chat.receiver == receiverId) {
      Navigator.push(
          context,
          MaterialPageRoute<ChatView>(
              builder: (BuildContext context) =>
                  ChatView(chat: chat, user: user)));
      return;
    }
  }

  Navigator.push(
      context,
      MaterialPageRoute<ChatView>(
          builder: (BuildContext context) => ChatView(chat: newChat)));
}

Chat getChat(BuildContext context, String receiverId) {
  ChatController chatController =
      Provider.of<ChatController>(context, listen: false);
  for (Chat chat in chatController.getChats) {
    if (chat.receiver == receiverId) {
      return chat;
    }
  }

  return Chat(receiverId, <Message>[], ChatType.private);
}
