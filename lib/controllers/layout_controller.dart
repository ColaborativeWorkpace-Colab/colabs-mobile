import 'package:flutter/material.dart';

class LayoutController extends ChangeNotifier {
  SearchFilter _currentSearchFilter = SearchFilter.social;
  final List<String> _tags = <String>[];

  set setSearchFilter(SearchFilter value) {
    _currentSearchFilter = value;
    notifyListeners();
  }

  void addTags(List<String> value) {
    List<String> cleanTags = _removeDuplicateTags(value);

    if (cleanTags.isNotEmpty) {
      _tags.addAll(cleanTags);
      notifyListeners();
    }
  }

  List<String> _removeDuplicateTags(List<String> value) {
    List<String> temp = <String>[];
    for (String element in value) {
      if (!_tags.contains(element)) temp.add(element);
    }
    return temp;
  }

  List<String> get getTags => _tags;
  SearchFilter get getSearchFilter => _currentSearchFilter;
}

enum SearchFilter {
  social,
  message,
  post,
  project,
  job,
}

extension SearchExtension on SearchFilter {
  String get name {
    switch (this) {
      case SearchFilter.job:
        return 'Jobs';
      case SearchFilter.project:
        return 'Projects';
      case SearchFilter.message:
        return 'Messages';
      default:
        return '';
    }
  }
}
