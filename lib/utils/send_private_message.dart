import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

void sendPrivateMessage(BuildContext context, Chat chat,
    {TextEditingController? messageController, String? message}) {
  ChatController chatController =
      Provider.of<ChatController>(context, listen: false);
  Authenticator authenticator =
      Provider.of<Authenticator>(context, listen: false);
  DateTime timeStamp = DateTime.now();
  String messageId = uuid.v4();
  // ignore: always_specify_types
  chatController.sendPrivateMessage({
    'senderId': authenticator.getUserId,
    'receiverId': chat.receiver,
    'message': (message == null) ? messageController!.text : message,
    'messageId': messageId,
    'timeStamp': timeStamp.toString(),
    'chatId': chat.chatId
  });

  chat.messages.add(Message(messageId, authenticator.getUserId!,
      (message == null) ? messageController!.text : message, timeStamp, false));

  if (chat.chatId == null) {
    chatController.addChat(chat, true);
  }

  if (messageController != null) messageController.clear();
}
