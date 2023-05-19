import 'package:colabs_mobile/components/job_application_container.dart';
import 'package:colabs_mobile/models/job.dart';
import 'package:flutter/material.dart';

class JobView extends StatelessWidget {
  final Job job;
  final ScrollController pageScrollController = ScrollController();
  JobView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: const Color(0xFF5521B5),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            controller: pageScrollController,
            child: Column(children: <Widget>[
              Container(
                  height: 150,
                  width: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            blurRadius: 15,
                            spreadRadius: 1,
                            color: Colors.grey[300]!)
                      ]),
                  child: const Image(
                      image: AssetImage('assets/images/company.png'))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(job.jobTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24)),
              ),
              Text(job.owner),
              Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: const Text('Overview',
                      style:
                          TextStyle(color: Color(0xFF5521B5), fontSize: 18))),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 30, bottom: 15),
                  child: Text(job.description)),
              Container(
                alignment: Alignment.centerLeft,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: const Text('Requirements',
                    style: TextStyle(color: Color(0xFF5521B5), fontSize: 18)),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 15),
                  //TODO: Make a horizontal carousel view for requirements
                  child: ListView.builder(
                      physics: const ScrollPhysics(),
                      itemCount: job.requirements.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            leading: const Icon(Icons.circle_outlined,
                                color: Color(0xFF5521B5)),
                            title: Text(job.requirements[index]));
                      })),
              JobApplicationContainer(scrollController: pageScrollController)
            ])));
  }
}
