import 'package:colabs_mobile/models/job.dart';
import 'package:colabs_mobile/types/job_bid.dart';
import 'package:flutter/material.dart';

class JobController extends ChangeNotifier {
  final List<Job> _jobs = <Job>[];
  DateTime? _jobDeadlineEstimate;
  JobBid _jobBid = JobBid.milestone;

  JobController();

  void addJob(Job value, {bool listen = true}) {
    if (!_jobExists(value.jobId)) _jobs.add(value);
    if (listen) notifyListeners();
  }

  bool _jobExists(String jobId) {
    for (Job job in _jobs) {
      if (job.jobId == jobId) return true;
    }

    return false;
  }

  set setJobDeadlineEstimate(DateTime? value) {
    _jobDeadlineEstimate = value;
    notifyListeners();
  }

  set setJobBid(JobBid value) {
    _jobBid = value;
    notifyListeners();
  }

  DateTime? get getJobDeadlineEstimate => _jobDeadlineEstimate;
  List<Job> get getJobs => _jobs;
  JobBid get getJobBid => _jobBid;
}
