import 'package:colabs_mobile/models/job.dart';
import 'package:flutter/material.dart';

class JobController extends ChangeNotifier {
  final List<Job> _jobs = <Job>[];

  JobController();

  void addJob(Job value, {bool listen = true}) {
    _jobs.add(value);
    if(listen) notifyListeners();
  }

  List<Job> get getJobs => _jobs;
}
