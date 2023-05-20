import 'package:colabs_mobile/controllers/content_controller.dart';

List<String>? filterTags(String value, ContentController contentController) {
  RegExp hashtagRegExp = RegExp(r"(?<=\s|^)#[\w-]+");
  Iterable<Match> hashtagMatches = hashtagRegExp.allMatches(value);

  if (hashtagMatches.isNotEmpty) {
    List<String> hashtags =
        hashtagMatches.map<String>((Match match) => match.group(0)!).toList();
    hashtags.removeWhere((String tag) => tag == "");
    contentController.addTags(hashtags);

    return hashtags;
  }

  return null;
}
