import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/models/chat.dart';
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
    socket!.onConnectError((err) => debugPrint(err));
    // ignore: always_specify_types
    socket!.onError((err) => debugPrint(err));
  }

  void disconnect() {
    socket!.emit('disconnect-user', _authenticator!.getUserId);
    socket!.disconnect();
    socket!.dispose();
    super.dispose();
  }

  set setAuthenticator(Authenticator value) {
    _authenticator = value;
  }

  List<Chat> get getChats => _chats;
}
