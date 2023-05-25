import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:flutter/material.dart';

class TeamTab extends StatelessWidget {
  const TeamTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: const CircleAvatar(),
                  title: const Text('User Name'),
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
            }),
        Positioned(
            bottom: 30,
            right: 15,
            child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConnectionsGridView(
                            layoutOption: ConnectionsLayoutOptions.add);
                      });
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15)),
                child: const Icon(Icons.add)))
      ],
    );
  }
}
