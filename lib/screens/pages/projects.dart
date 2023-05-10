import 'package:colabs_mobile/components/navbar.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: <Widget>[
      const Navbar(searchFilter: SearchFilter.project),
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 95),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/projectview', arguments: {"data": ''});
                    },
                    title: const Text('Project Name'),
                    trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                  value: 'Option 1', child: Text('Option 1')),
                              const PopupMenuItem<String>(
                                  value: 'Delete', child: Text('Delete')),
                              const PopupMenuItem<String>(
                                  value: 'Option 1', child: Text('Option 1'))
                            ]));
              }))
    ]));
  }
}
