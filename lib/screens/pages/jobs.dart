import 'package:colabs_mobile/components/job_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/job_controller.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:colabs_mobile/utils/initialize_services.dart';
import 'package:colabs_mobile/utils/pop_up_verification_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    JobController jobController = Provider.of<JobController>(context);
    RESTService restService = Provider.of<RESTService>(context);
    LayoutController layoutController = Provider.of<LayoutController>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (restService.getProfileInfo['isVerified'] != null &&
        restService.getProfileInfo['isVerified']) {
      popUpVerificationAlert(context, true);
    }

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.job),
      SizedBox(
          height: screenHeight * .8,
          width: screenWidth,
          child: Stack(children: <Widget>[
            (jobController.getJobs.isNotEmpty)
                ? RefreshIndicator(
                    onRefresh: () => initServices(context, reload: true)
                        .whenComplete(() => layoutController.refresh(true)),
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 95),
                        itemCount: jobController.getJobs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return JobContainer(
                              job: jobController.getJobs[index]);
                        }))
                : Positioned(
                    top: screenHeight * .25,
                    left: screenWidth * .17,
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
                        ]))),
            Positioned(
                bottom: 75,
                right: 10,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15)),
                    child: const Icon(Icons.add, size: 30),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            GlobalKey<FormState> formKey = GlobalKey();
                            TextEditingController titleController =
                                TextEditingController();
                            TextEditingController descriptionController =
                                TextEditingController();
                            TextEditingController requirementsController =
                                TextEditingController();
                            TextEditingController payRateController =
                                TextEditingController();

                            return AlertDialog(
                                title: const Text('Create Job'),
                                content: Form(
                                    key: formKey,
                                    child: SingleChildScrollView(
                                      child: Column(children: <Widget>[
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              validator: (String? value) =>
                                                  value == null || value.isEmpty
                                                      ? 'Empty field'
                                                      : null,
                                              controller: titleController,
                                              decoration: InputDecoration(
                                                  label: const Text('Title'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              validator: (String? value) =>
                                                  value == null || value.isEmpty
                                                      ? 'Empty field'
                                                      : null,
                                              minLines: 5,
                                              maxLines: 5,
                                              controller: descriptionController,
                                              decoration: InputDecoration(
                                                  label:
                                                      const Text('Description'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              validator: (String? value) =>
                                                  value == null || value.isEmpty
                                                      ? 'Empty field'
                                                      : null,
                                              controller:
                                                  requirementsController,
                                              decoration: InputDecoration(
                                                  label: const Text(
                                                      'Requirements'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            width: screenWidth,
                                            child: TextFormField(
                                                controller: payRateController,
                                                validator: (String? value) =>
                                                    value == null ||
                                                            value.isEmpty
                                                        ? 'Empty field'
                                                        : null,
                                                keyboardType: TextInputType
                                                    .number,
                                                decoration: InputDecoration(
                                                    label: const Text(
                                                        'Hourly Rate'),
                                                    suffixText: 'ETB/hr',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20))))),
                                      ]),
                                    )),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        bool isValid =
                                            formKey.currentState!.validate();

                                        if (!isValid) return;
                                        formKey.currentState!.save();

                                        // ignore: always_specify_types
                                        restService.postJobRequest({
                                          'recruiterId':
                                              authenticator.getUserId,
                                          'title': titleController.text,
                                          'description':
                                              descriptionController.text,
                                          'requirements': requirementsController
                                              .text
                                              .split(','),
                                          'earnings': double.parse(
                                              payRateController.text),
                                        }).whenComplete(
                                            () => Navigator.pop(context));
                                      },
                                      child: const Text('Post Job'))
                                ]);
                          });
                    }))
          ]))
    ]));
  }
}
