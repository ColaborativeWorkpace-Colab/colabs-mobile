import 'package:colabs_mobile/components/job_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/job_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:colabs_mobile/utils/pop_up_verification_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    JobController jobController = Provider.of<JobController>(context);
    RESTService restService = Provider.of<RESTService>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    popUpVerificationAlert(context, restService.getProfileInfo['isVerified']);

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.job),
      (jobController.getJobs.isNotEmpty)
          ? Expanded(
              child: RefreshIndicator(
              onRefresh: () => restService.getJobsRequest(listen: true),
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 95),
                  itemCount: jobController.getJobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return JobContainer(job: jobController.getJobs[index]);
                  }),
            ))
          : Container(
              margin: EdgeInsets.only(top: screenHeight * .25),
              child: SizedBox(
                  width: screenWidth * .7,
                  child: Column(children: <Widget>[
                    const Icon(Icons.work, color: Colors.grey, size: 80),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        '''No available jobs currently.''',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          restService.isRefreshing = true;
                          restService
                              .getJobsRequest()
                              .timeout(const Duration(seconds: 10),
                                  onTimeout: () =>
                                      restService.isRefreshing = false)
                              .then((bool value) {
                            restService.isRefreshing = false;
                          });
                        },
                        child: (!restService.isRefreshing)
                            ? const Icon(Icons.refresh)
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ))
                  ])))
    ]));
  }
}
