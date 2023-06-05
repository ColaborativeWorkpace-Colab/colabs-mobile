import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/models/project.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamTab extends StatelessWidget {
  final Project project;
  const TeamTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    LayoutController layoutController = Provider.of<LayoutController>(context);

    return Stack(
      children: <Widget>[
        project.members.isNotEmpty
            ? ListView.builder(
                itemCount: project.members.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading: const CircleAvatar(),
                      title: Text(project.members[index]),
                      trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                    value: 'Permissions',
                                    child: Text('Permissions')),
                                const PopupMenuItem<String>(
                                    value: 'Remove', child: Text('Remove'))
                              ]));
                })
            : Container(
                margin: EdgeInsets.only(top: screenHeight * .25),
                child: SizedBox(
                    width: screenWidth,
                    child: Column(children: <Widget>[
                      const Icon(Icons.people_rounded,
                          color: Colors.grey, size: 80),
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: const Text('''No members in this project.''',
                              textAlign: TextAlign.center))
                    ]))),
        Positioned(
            bottom: 30,
            right: 15,
            child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ConnectionsGridView(
                            layoutOption: ConnectionsLayoutOptions.add,
                            project: project);
                      }).whenComplete(() => layoutController.refresh(true));
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15)),
                child: const Icon(Icons.add)))
      ],
    );
  }
}
