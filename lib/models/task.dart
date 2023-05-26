import 'package:colabs_mobile/types/task_status.dart';

class Task {
  final String taskId;
  final String taskTitle;
  final String description;
  final List<String> assignees;
  final DateTime? deadline;
  TaskStatus status;

  Task(this.taskId, this.taskTitle, this.description, this.status, this.assignees, {this.deadline});
}
