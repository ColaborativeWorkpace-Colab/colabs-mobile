import 'package:colabs_mobile/components/job_container.dart';
import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:flutter/material.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.job),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 95),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return JobContainer(
              jobTitle: 'Sample Title',
              timeStamp: DateTime.now(),
              description: 'This is a sample description',
              requirements: const <String>[
                'Requirement1',
                'Requirement1',
                'Requirement1',
                'Requirement1',
              ],
            );
          },
        ),
      )
    ]));
  }
}
