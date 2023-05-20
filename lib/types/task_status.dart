enum TaskStatus { queued, ongoing, completed }

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.queued:
        return 'Queued';
      case TaskStatus.ongoing:
        return 'Ongoing';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}

TaskStatus mapTaskStatusEnum(String value) {
  switch (value) {
    case 'Ongoing':
      return TaskStatus.ongoing;
    case 'Completed':
      return TaskStatus.completed;
    default:
      return TaskStatus.queued;
  }
}
