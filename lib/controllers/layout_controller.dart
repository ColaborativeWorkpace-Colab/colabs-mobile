import 'package:flutter/material.dart';

class LayoutController extends ChangeNotifier {
  SearchFilter _currentSearchFilter = SearchFilter.social;
  int _loginInitRefreshCount = 1;

  void refresh() {
    if (_loginInitRefreshCount != 0) {
      _loginInitRefreshCount--;
      notifyListeners();
    }
  }

  void loggingOut() => _loginInitRefreshCount++;

  set setSearchFilter(SearchFilter value) {
    _currentSearchFilter = value;
    notifyListeners();
  }

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
