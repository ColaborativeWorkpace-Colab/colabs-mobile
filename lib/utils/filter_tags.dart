import 'package:colabs_mobile/controllers/content_controller.dart';

void filterTags(String value, ContentController contentController) {
  Future<void>.delayed(const Duration(seconds: 2), () {
    RegExp hashtagRegExp = RegExp(r"(?<=\s|^)#[\w-]+");
    Iterable<Match> hashtagMatches = hashtagRegExp.allMatches(value);

    if (hashtagMatches.isNotEmpty) {
      List<String> hashtags =
          hashtagMatches.map<String>((Match match) => match.group(0)!).toList();
      contentController.addTags(hashtags);
    }
  });
}
