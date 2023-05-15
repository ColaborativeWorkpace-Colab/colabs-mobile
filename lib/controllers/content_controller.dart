import 'dart:io';
import 'package:flutter/material.dart';

class ContentController extends ChangeNotifier {
  final List<File> _attachements = <File>[];
  final List<String> _tags = <String>[];
  final List<String> _taggedUsers = <String>[];
  bool _isPublic = false;
  bool _isDonatable = false;

  void addAttachements(List<File> files) {
    _attachements.addAll(files);
    notifyListeners();
  }

  void removeAttachement(File file) {
    _attachements.remove(file);
    notifyListeners();
  }

  void addTags(List<String> value) {
    List<String> cleanTags = _removeDuplicateTags(value);

    if (cleanTags.isNotEmpty) {
      _tags.addAll(cleanTags);
      notifyListeners();
    }
  }

  void tagUser(String value) {
    _taggedUsers.add(value);
    notifyListeners();
  }

  void untagUser(String value) {
    _taggedUsers.remove(value);
    notifyListeners();
  }

  void clearInputs() {
    _taggedUsers.clear();
    _attachements.clear();
    notifyListeners();
  }

  List<String> _removeDuplicateTags(List<String> value) {
    List<String> temp = <String>[];
    for (String element in value) {
      if (!_tags.contains(element)) temp.add(element);
    }
    return temp;
  }

  set setIsPublic(bool value) {
    _isPublic = value;
    notifyListeners();
  }

  set setIsDonatable(bool value) {
    _isDonatable = value;
    notifyListeners();
  }

  List<String> get getTags => _tags;
  List<String> get getTaggedUsers => _taggedUsers;
  List<File> get getAttachments => _attachements;
  bool get getIsPublic => _isPublic;
  bool get getIsDonatable => _isDonatable;
}
