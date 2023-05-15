import 'package:colabs_mobile/models/message.dart';

class Chat {
  final List<Message> messages;
  final String user;

  Chat(this.user, this.messages);
}
