import 'package:colabs_mobile/types/job_status.dart';

class Job {
  final String jobId;
  final String jobTitle;
  final String description;
  final JobStatus status;
  final List<String> workers;
  final List<String> requirements;
  final bool isPaymentVerified;
  final double earnings;
  final String owner;

  Job(this.jobId, this.jobTitle, this.description, this.status, this.workers,
      this.requirements, this.earnings, this.owner, this.isPaymentVerified);
}
