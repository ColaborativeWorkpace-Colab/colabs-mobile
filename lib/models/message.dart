class Message {
  final DateTime timeStamp;
  final bool isRead;
  final String messageText;

  Message(this.messageText, this.timeStamp, this.isRead);
}
