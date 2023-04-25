import 'package:colabs_mobile/components/navbar.dart';
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
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return const ListTile(
              title: Text('Job Title'),
              subtitle: Text('Job Description'),
            );
          },
        ),
      )
    ]));
  }
}
