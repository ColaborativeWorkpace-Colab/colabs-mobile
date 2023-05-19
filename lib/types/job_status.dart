enum JobStatus { pending, completed, active, ready, available }

extension JobStatusExtension on JobStatus {
  String get name {
    switch (this) {
      case JobStatus.pending:
        return 'Pending';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.active:
        return 'Active';
      case JobStatus.ready:
        return 'Ready';
      case JobStatus.available:
        return 'Available';
    }
  }
}

JobStatus mapStatusEnum(String value) {
  switch (value) {
    case 'Pending':
      return JobStatus.pending;
    case 'Completed':
      return JobStatus.completed;
    case 'Active':
      return JobStatus.active;
    case 'Ready':
      return JobStatus.ready;
    default:
      return JobStatus.available;
  }
}
