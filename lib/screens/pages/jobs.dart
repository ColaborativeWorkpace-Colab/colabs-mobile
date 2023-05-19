import 'package:colabs_mobile/components/job_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/job_controller.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    JobController jobController = Provider.of<JobController>(context);

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.job),
      Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 95),
              itemCount: jobController.getJobs.length,
              itemBuilder: (BuildContext context, int index) {
                return JobContainer(job: jobController.getJobs[index]);
              }))
    ]));
  }
}
