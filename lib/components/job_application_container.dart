import 'package:colabs_mobile/components/version_tab.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/job_controller.dart';
import 'package:colabs_mobile/controllers/project_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/job.dart';
import 'package:colabs_mobile/types/job_bid.dart';
import 'package:colabs_mobile/types/job_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JobApplicationContainer extends StatefulWidget {
  final Job job;
  final ScrollController scrollController;
  const JobApplicationContainer(
      {super.key, required this.job, required this.scrollController});

  @override
  // ignore: library_private_types_in_public_api
  _JobApplicationContainerState createState() =>
      _JobApplicationContainerState();
}

class _JobApplicationContainerState extends State<JobApplicationContainer>
    with TickerProviderStateMixin {
  final TextEditingController payRateController = TextEditingController();
  final TextEditingController coverLetterController = TextEditingController();
  AnimationController? _controller;
  Animation<double>? _animation;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isTransitioning = false;
  bool _isExtended = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> _toggleContainer() async {
    if (_animation!.status != AnimationStatus.completed) {
      setState(() {
        _isExtended = true;
        _isTransitioning = true;
      });
      await widget.scrollController.animateTo(450,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutExpo);
      await _controller!.forward();
      setState(() {
        _isTransitioning = false;
      });
    } else {
      await _controller!
          .animateBack(0, duration: const Duration(milliseconds: 500));
      setState(() {
        _isExtended = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    JobController jobController = Provider.of<JobController>(context);
    RESTService restService = Provider.of<RESTService>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);
    Widget changeJobStatusButton;

    if (widget.job.pendingWorkers.contains(authenticator.getUserId)) {
      changeJobStatusButton = Row(children: const <Widget>[
        SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
        SizedBox(width: 20),
        Text('Proposal Pending')
      ]);
    } else if (widget.job.status == JobStatus.active) {
      changeJobStatusButton = ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child:
              const Text('Complete Job', style: TextStyle(color: Colors.white)),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  ProjectController projectController =
                      Provider.of<ProjectController>(context);

                  return SizedBox(
                      height: screenHeight * .35,
                      child: Column(children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                                'Select project for job completion',
                                style: TextStyle(
                                    color: Color(0xFF5521B5), fontSize: 18))),
                        SizedBox(
                          height: screenHeight * .23,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: projectController.getProjects.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    leading: Checkbox(
                                        onChanged: (bool? value) {},
                                        value: false),
                                    title: Text(projectController
                                        .getProjects[index].projectName));
                              }),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              //TODO: Send request for job completion
                            },
                            child: const Text('Prepare Files'))
                      ]));
                });
          });
    } else if (widget.job.status == JobStatus.ready) {
      changeJobStatusButton = Row(children: const <Widget>[
        SizedBox(width: 20),
        Text('Waiting for recruiter approval')
      ]);
    } else if (widget.job.status == JobStatus.completed) {
      changeJobStatusButton = Row(children: const <Widget>[
        Icon(Icons.check_circle, color: Colors.green),
        SizedBox(width: 20),
        Text('Job Completed')
      ]);
    } else {
      changeJobStatusButton = ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: const Text('Apply Now', style: TextStyle(color: Colors.white)),
          onPressed: () => _toggleContainer());
    }

    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF5521B5), width: 1)),
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.favorite_border_outlined,
                        color: Colors.red),
                    onPressed: () {}),
                changeJobStatusButton,
                _isExtended
                    ? const SizedBox()
                    : _isExtended
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _toggleContainer())
                        : SizedBox(width: screenWidth * .1)
              ]),
          SizeTransition(
              sizeFactor: _animation!,
              axis: Axis.vertical,
              child: Form(
                  key: formKey,
                  child: Column(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        alignment: Alignment.centerLeft,
                        child: const Text('Project Bid',
                            style: TextStyle(fontSize: 16))),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.grey[400]!, width: 1)),
                        child: Column(children: <Widget>[
                          SizedBox(
                              height: 50,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                        width: screenWidth * .35,
                                        height: 50,
                                        child: ListTile(
                                            horizontalTitleGap: 1,
                                            contentPadding: EdgeInsets.zero,
                                            title: const Text('By Milestone',
                                                style: TextStyle(fontSize: 12)),
                                            leading: Radio<JobBid>(
                                                value: jobController.getJobBid,
                                                groupValue: JobBid.milestone,
                                                onChanged: (JobBid? value) {
                                                  jobController.setJobBid =
                                                      JobBid.milestone;
                                                }))),
                                    SizedBox(
                                        width: screenWidth * .3,
                                        height: 50,
                                        child: ListTile(
                                            horizontalTitleGap: 1,
                                            contentPadding: EdgeInsets.zero,
                                            title: const Text('By Project',
                                                style: TextStyle(fontSize: 12)),
                                            leading: Radio<JobBid>(
                                                value: jobController.getJobBid,
                                                groupValue: JobBid.project,
                                                onChanged: (JobBid? value) {
                                                  jobController.setJobBid =
                                                      JobBid.project;
                                                })))
                                  ])),
                          Text(jobController.getJobBid.name)
                        ])),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: TextFormField(
                            controller: coverLetterController,
                            validator: (String? value) =>
                                value == null || value.isEmpty
                                    ? 'Empty Field'
                                    : null,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                label: const Text('Cover Letter'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))))),
                    Row(children: <Widget>[
                      Container(
                          width: screenWidth * .37,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                              controller: payRateController,
                              validator: (String? value) =>
                                  value == null || value.isEmpty
                                      ? 'Empty field'
                                      : null,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  label: const Text('Hourly Rate'),
                                  suffixText: 'ETB/hr',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20))))),
                      Container(
                          width: screenWidth * .35,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                              validator: (String? value) =>
                                  value == null || value.isEmpty
                                      ? 'Empty field'
                                      : null,
                              controller: TextEditingController(
                                  text: (jobController.getJobDeadlineEstimate !=
                                          null)
                                      ? DateFormat('M-d-yyyy').format(
                                          jobController.getJobDeadlineEstimate!)
                                      : null),
                              decoration: InputDecoration(
                                  label: const Text('Deadline'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                jobController.setJobDeadlineEstimate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate:
                                      jobController.getJobDeadlineEstimate ??
                                          DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                              }))
                    ]),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                            onPressed: () {
                              bool isValid = formKey.currentState!.validate();

                              if (!isValid) return;
                              formKey.currentState!.save();

                              // ignore: always_specify_types
                              restService.applyJobRequest(widget.job.jobId, {
                                'workerId': authenticator.getUserId,
                                'estimatedDeadline': jobController
                                    .getJobDeadlineEstimate
                                    .toString(),
                                'payRate': payRateController.text,
                                'coverLetter': coverLetterController.text,
                                'workBid': (jobController.getJobBid ==
                                        JobBid.milestone)
                                    ? 'By Milestone'
                                    : 'By Project'
                              }).then((bool requestSuccess) {
                                if (requestSuccess) {
                                  widget.job.pendingWorkers
                                      .add(authenticator.getUserId!);
                                }
                                _toggleContainer();
                              });
                            },
                            child: const Text('Submit Proposal')))
                  ]))),
          _isTransitioning == true
              ? const SizedBox(height: 400)
              : const SizedBox()
        ]));
  }
}
