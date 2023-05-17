enum ConnectionsLayoutOptions {
  tag,
  send,
  chat
}

extension ConnectionsLayoutOptionsExtension on ConnectionsLayoutOptions {
  String get name {
    switch (this) {
      case ConnectionsLayoutOptions.tag:
        return 'Tag your connections';
      case ConnectionsLayoutOptions.send:
        return 'Send to...';
      case ConnectionsLayoutOptions.chat:
        return 'Chat with...';
      default:
        return '';
    }
  }
}
