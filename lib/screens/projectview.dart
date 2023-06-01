import 'package:colabs_mobile/components/project_overview_tab.dart';
import 'package:colabs_mobile/components/team_tab.dart';
import 'package:colabs_mobile/components/version_tab.dart';
import 'package:colabs_mobile/models/project.dart';
import 'package:flutter/material.dart';

class ProjectView extends StatelessWidget {
  final Project project;
  const ProjectView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    //TODO: Get file versions from server
    return Scaffold(
        appBar: AppBar(title: const Text('Project Details')),
        body: DefaultTabController(
            length: 3,
            child: Column(children: <Widget>[
              const TabBar(
                tabs: <Widget>[
                  Tab(
                      child: Text('Progress',
                          style: TextStyle(color: Color(0xff5521B5)))),
                  Tab(
                      child: Text('Versions',
                          style: TextStyle(color: Color(0xff5521B5)))),
                  Tab(
                      child: Text('Teams',
                          style: TextStyle(color: Color(0xff5521B5)))),
                ]
              ),
              Expanded(
                  child: TabBarView(children: <Widget>[
                ProjectOverviewTab(project: project),

                VersionTab(files: project.files),

                const TeamTab()
              ]))
            ])));
  }
}
