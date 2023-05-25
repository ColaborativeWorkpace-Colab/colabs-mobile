enum ConnectionsLayoutOptions { tag, send, chat, add }

extension ConnectionsLayoutOptionsExtension on ConnectionsLayoutOptions {
  String get name {
    switch (this) {
      case ConnectionsLayoutOptions.tag:
        return 'Tag your connections';
      case ConnectionsLayoutOptions.send:
        return 'Send to...';
      case ConnectionsLayoutOptions.chat:
        return 'Chat with...';
      case ConnectionsLayoutOptions.add:
        return 'Add Members';
      default:
        return '';
    }
  }
}
