import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/types/chat_type.dart';

class Chat {
  String? chatId;
  final List<Message> messages;
  final String receiver;
  final ChatType type;

  Chat(this.receiver, this.messages, this.type, [this.chatId]);
}
