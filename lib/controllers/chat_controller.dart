import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  Authenticator? _authenticator;
  final String urlHost = dotenv.env['DEV_URL']!;
  final List<Chat> _chats = <Chat>[];
  Socket? socket;

  ChatController();

  void initSocket() {
    socket = io(Uri.http(urlHost).toString(), <String, dynamic>{
      'autoConnect': true,
      'transports': <String>['websocket'],
    });
    socket!.connect();
    socket!.onConnect((_) {
      socket!.emit('connect-user', _authenticator!.getUserId);
      debugPrint('Connection Established');
    });

    socket!.onDisconnect((_) => debugPrint('Connection Disconnection'));
    // ignore: always_specify_types
    socket!.onConnectError((err) => debugPrint(
      err));
    // ignore: always_specify_types
    socket!.onError((err) => debugPrint(err));
    // ignore: always_specify_types
    socket!.on('receive_chat_id', (data) => _linkChatId(data));
    // ignore: always_specify_types
    socket!.on('chat_error', (errorMessage) => removeChat());
    // ignore: always_specify_types
    socket!.on('is_not_online', (timeStamp) {
      socket!.disconnect();
      socket!.dispose();
    });
  }

  void disconnect() =>
      socket!.emit('disconnect-user', _authenticator!.getUserId);

  // ignore: always_specify_types
  void _linkChatId(data) {
    Map<String, dynamic> mapData = data as Map<String, dynamic>;

    for (Chat chat in _chats) {
      if (chat.receiver == mapData['receiverId']) {
        chat.chatId = mapData['chatId'];
      }
    }
  }

  void removeChat() {
    Chat? toBeRemoved;

    for (Chat chat in _chats) {
      if (chat.chatId == null) {
        toBeRemoved = chat;
        break;
      }
    }

    if (toBeRemoved != null) _chats.remove(toBeRemoved);
  }

  void sendPrivateMessage(Map<String, dynamic> data) =>
      socket!.emit('private-message', data);

  void sendGroupMessage(Map<String, dynamic> data) =>
      socket!.emit('group-message', data);

  void markAsRead(Chat chat) {
    socket!.emit('mark-read', chat.chatId);
    _markAllMessagesAsRead(chat);
  }

  void _markAllMessagesAsRead(Chat chat) {
    for (Message message in chat.messages) {
      message.isRead = true;
    }
  }

  void addChat(Chat chat, bool listen) {
    if (chat.chatId == null || !_chatExists(chat.chatId!)) _chats.add(chat);
    if (listen) notifyListeners();
  }

  bool _chatExists(String chatId) {
    for (Chat chat in _chats) {
      if (chat.chatId == chatId) return true;
    }

    return false;
  }

  void refresh() {
    notifyListeners();
  }

  set setAuthenticator(Authenticator value) {
    _authenticator = value;
  }

  List<Chat> get getChats => _chats;
}
