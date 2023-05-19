import 'package:colabs_mobile/models/job.dart';
import 'package:flutter/material.dart';

class JobController extends ChangeNotifier {
  final List<Job> _jobs = <Job>[];

  JobController();

  void addJob(Job value, {bool listen = true}) {
    if(!_jobExists(value.jobId)) _jobs.add(value);
    if(listen) notifyListeners();
  }

  bool _jobExists(String jobId) {
    for (Job job in _jobs) {
      if (job.jobId == jobId) return true;
    }

    return false;
  }

  List<Job> get getJobs => _jobs;
}
