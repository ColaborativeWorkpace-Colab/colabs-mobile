import 'package:colabs_mobile/models/message.dart';

class Chat {
  final String? chatId;
  final List<Message> messages;
  final String receiver;

  Chat(this.receiver, this.messages, [this.chatId]);
}
