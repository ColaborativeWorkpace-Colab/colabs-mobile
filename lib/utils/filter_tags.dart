import 'package:colabs_mobile/controllers/layout_controller.dart';

void filterTags(String value, LayoutController layoutController) {
  Future<void>.delayed(const Duration(seconds: 2), () {
    RegExp hashtagRegExp = RegExp(r"(?<=\s|^)#[\w-]+");
    Iterable<Match> hashtagMatches = hashtagRegExp.allMatches(value);

    if (hashtagMatches.isNotEmpty) {
      List<String> hashtags =
          hashtagMatches.map<String>((Match match) => match.group(0)!).toList();
      layoutController.addTags(hashtags);
    }
  });
}
