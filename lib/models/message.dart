class Message {
  final String messageId;
  final DateTime timeStamp;
  final bool isRead;
  final String messageText;
  final String senderId;

  Message(this.messageId, this.senderId, this.messageText, this.timeStamp, this.isRead);
}
