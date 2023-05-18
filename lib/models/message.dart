class Message {
  final String messageId;
  final DateTime timeStamp;
  final String messageText;
  final String senderId;
  bool isRead;

  Message(this.messageId, this.senderId, this.messageText, this.timeStamp, this.isRead);
}
