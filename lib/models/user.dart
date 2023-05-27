class User {
  final String userId;
  String? userName;
  bool? isOnline;
  DateTime? lastSeen;

  User(this.userId, {this.userName, this.isOnline, this.lastSeen});
}
