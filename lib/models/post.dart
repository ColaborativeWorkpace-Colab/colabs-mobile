import 'package:colabs_mobile/models/post_comment.dart';

class Post {
  final String postId;
  final String textContent;
  final String imageContentUrl;
  final String postOwnerId;
  final DateTime timeStamp;
  final List<dynamic> likeCount;
  final List<dynamic> tags;
  final List<PostComment> comments;
  final bool isDonatable;

  Post(this.postId, this.postOwnerId, this.textContent, this.imageContentUrl,
      this.timeStamp, this.tags, this.likeCount, this.comments, this.isDonatable);
}
