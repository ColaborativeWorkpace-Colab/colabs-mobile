import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/project_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/screens/projectview.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:colabs_mobile/utils/pop_up_verification_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectController projectController =
        Provider.of<ProjectController>(context);
    RESTService restService = Provider.of<RESTService>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if(restService.getProfileInfo['isVerified'] != null && restService.getProfileInfo['isVerified']){
      popUpVerificationAlert(context, true);
    }

    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.project),
      (projectController.getProjects.isNotEmpty)
          ? Expanded(
              child: RefreshIndicator(
                  onRefresh: () => restService.getProjectsRequest(listen: true),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 95),
                      itemCount: projectController.getProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 3)
                                ],
                                color: Colors.white),
                            child: ListTile(
                                onTap: () {
                                  restService.isFetching = true;
                                  restService.getProjectFilesRequest(
                                      projectController.getProjects[index].projectId);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<ProjectView>(
                                          builder: (BuildContext context) =>
                                              ProjectView(
                                                  project: projectController
                                                      .getProjects[index])));
                                },
                                title: Text(projectController
                                    .getProjects[index].projectName),
                                trailing: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                              value: 'Delete',
                                              child: Text('Delete'))
                                        ])));
                      })))
          : Container(
              margin: EdgeInsets.only(top: screenHeight * .25),
              child: SizedBox(
                  width: screenWidth * .7,
                  child: Column(children: <Widget>[
                    const Icon(Icons.folder, color: Colors.grey, size: 80),
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: const Text(
                            '''You currently do not have any projects.''',
                            textAlign: TextAlign.center)),
                    ElevatedButton(
                        onPressed: () {
                          restService.isRefreshing = true;
                          restService
                              .getProjectsRequest()
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
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white)))
                  ])))
    ]));
  }
}
