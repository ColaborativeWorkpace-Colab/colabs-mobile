import 'package:colabs_mobile/models/post_comment.dart';

class Post {
  final String postId;
  final String textContent;
  final String imageContentUrl;
  final String postOwnerId;
  final DateTime timeStamp;
  final List<dynamic> likes;
  final List<String> tags;
  final List<PostComment> comments;
  final bool isDonatable;

  Post(this.postId, this.postOwnerId, this.textContent, this.imageContentUrl,
      this.timeStamp, this.tags, this.likes, this.comments, this.isDonatable);
}
