import 'package:colabs_mobile/models/task.dart';

class Project {
  final String projectId;
  final String projectName;
  final List<Task> tasks;
  final List<dynamic> files;
  final List<String> members;

  Project(this.projectId, this.projectName, this.tasks, this.files, this.members);
}
