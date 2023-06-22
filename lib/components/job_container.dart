import 'package:colabs_mobile/models/job.dart';
import 'package:colabs_mobile/screens/jobview.dart';
import 'package:colabs_mobile/types/job_status.dart';
import 'package:flutter/material.dart';

class JobContainer extends StatelessWidget {
  final Job job;

  const JobContainer({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Widget jobStatusIndicator;
    //TODO: Notify user if job request proposal was rejected
    
    if (job.pendingWorkers.isNotEmpty) {
      jobStatusIndicator = Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: <Widget>[
            const Icon(Icons.people, color: Colors.grey),
            const SizedBox(width: 5),
            Text('${job.pendingWorkers.length.toString()} Applying',
                style: const TextStyle(color: Colors.grey))
          ]));
    } else if (job.status == JobStatus.active ||
        job.status == JobStatus.ready) {
      jobStatusIndicator = Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text('Active', style: TextStyle(color: Colors.green)));
    } else {
      jobStatusIndicator = const SizedBox();
    }

    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 5)
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: Text(job.jobTitle,
                            style: const TextStyle(fontSize: 25))),
                    jobStatusIndicator
                  ]),
              (job.requirements.isNotEmpty)
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 50,
                      width: screenWidth * .9,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: job.requirements.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child:
                                    Chip(label: Text(job.requirements[index])));
                          }),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(job.description)),
              (job.description.isNotEmpty)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<JobView>(
                                            builder: (BuildContext context) =>
                                                JobView(job: job)));
                                  },
                                  child: const Text('More',
                                      style: TextStyle(
                                          color: Color(0xFF5521B5),
                                          fontWeight: FontWeight.bold))))
                        ])
                  : const SizedBox(),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Chip(
                      backgroundColor: job.isPaymentVerified
                          ? const Color(0xFF5521B5)
                          : Colors.grey[300],
                      label: job.isPaymentVerified
                          ? GestureDetector(
                              onTap: () {
                                //TODO: Display payment information when job is verified
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => SizedBox(
                                        height: screenHeight * .5,
                                        child: const Center(
                                            child: Text(
                                                'Payment Method Information'))));
                              },
                              child: SizedBox(
                                  width: 150,
                                  child: Row(children: const <Widget>[
                                    Icon(
                                      Icons.payment,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Payment Verified',
                                        style: TextStyle(color: Colors.white))
                                  ])))
                          : SizedBox(
                              width: 170,
                              child: Row(children: const <Widget>[
                                Icon(Icons.payment, color: Colors.white),
                                SizedBox(width: 10),
                                Text('Payment Unverified',
                                    style: TextStyle(color: Colors.white))
                              ]))))
            ]));
  }
}
