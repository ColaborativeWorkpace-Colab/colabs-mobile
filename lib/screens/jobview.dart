import 'package:colabs_mobile/components/job_application_container.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/models/job.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

class JobView extends StatelessWidget {
  final Job job;
  final ScrollController pageScrollController = ScrollController();
  JobView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    LayoutController layoutController = Provider.of<LayoutController>(context);
    List<List<String>> requirements = partition(job.requirements, 3).toList();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: const Color(0xFF5521B5),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            controller: pageScrollController,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              Container(
                  margin: const EdgeInsets.all(10),
                  height: 150,
                  width: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                  width: screenWidth,
                  margin: const EdgeInsets.only(left: 20, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                            onPageChanged: (int pageIndex) {
                              layoutController.setPageIndex = pageIndex;
                            },
                            clipBehavior: Clip.antiAlias,
                            itemCount: requirements.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(children: <ListTile>[
                                ...requirements[index]
                                    .map((String requirement) => ListTile(
                                        horizontalTitleGap: 1,
                                        leading: Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: const Icon(Icons.circle,
                                              size: 10,
                                              color: Color(0xFF5521B5)),
                                        ),
                                        title: Text(requirement)))
                              ]);
                            }),
                      ),
                      requirements.length > 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  ...requirements.map<Widget>(
                                      (List<String> pageIndex) => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 10,
                                          width: 10,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                layoutController.getPageIndex ==
                                                        requirements
                                                            .indexOf(pageIndex)
                                                    ? const Color.fromARGB(
                                                        255, 132, 84, 222)
                                                    : Colors.grey[500],
                                          )))
                                ])
                          : const SizedBox()
                    ],
                  )),
              JobApplicationContainer(scrollController: pageScrollController),
              const SizedBox(height: 35)
            ])));
  }
}
