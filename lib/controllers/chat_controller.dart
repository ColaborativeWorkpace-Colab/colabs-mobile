import 'package:colabs_mobile/models/chat.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final List<Chat> _chats = <Chat>[];

  ChatController();

  List<Chat> get getChats => _chats;
}
