import 'package:colabs_mobile/types/search_filters.dart';
import 'package:flutter/material.dart';

class LayoutController extends ChangeNotifier {
  SearchFilter _currentSearchFilter = SearchFilter.social;
  int _loginInitRefreshCount = 1;
  int _pageIndex = 0;

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

  set setPageIndex(int value) {
    _pageIndex = value;
    notifyListeners();
  }

  SearchFilter get getSearchFilter => _currentSearchFilter;
  int get getPageIndex => _pageIndex;
}
