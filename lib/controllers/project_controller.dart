import 'package:colabs_mobile/models/project.dart';
import 'package:flutter/material.dart';

class ProjectController extends ChangeNotifier {
  final List<Project> _projects = <Project>[];

  ProjectController();

  void addProject(Project project, bool listen) {
    if (!_projectExists(project.projectId)) _projects.add(project);
    if (listen) notifyListeners();
  }

  bool _projectExists(String projectId) {
    for (Project project in _projects) {
      if (project.projectId == projectId) return true;
    }

    return false;
  }

  List<Project> get getProjects => _projects;
}
