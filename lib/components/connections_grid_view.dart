import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/project.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:colabs_mobile/utils/connection_view_functions.dart';
import 'package:colabs_mobile/utils/send_private_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionsGridView extends StatelessWidget {
  final ConnectionsLayoutOptions layoutOption;
  final String? shareLink;
  final Project? project;
  const ConnectionsGridView(
      {super.key, required this.layoutOption, this.shareLink, this.project});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    RESTService restService = Provider.of<RESTService>(context);
    ContentController contentController =
        Provider.of<ContentController>(context);

    return Container(
        margin: const EdgeInsets.all(10),
        height: screenHeight * .4,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(layoutOption.name, style: const TextStyle(fontSize: 17)),
                layoutOption == ConnectionsLayoutOptions.send ||
                        layoutOption == ConnectionsLayoutOptions.add
                    ? ElevatedButton(
                        onPressed: () {
                          if (layoutOption == ConnectionsLayoutOptions.add) {
                            List<String> newMembers = <String>[];

                            for (String newMember
                                in contentController.getTaggedUsers) {
                              if (!project!.members.contains(newMember)) {
                                newMembers.add(newMember);
                              }
                            }

                            if (newMembers.isNotEmpty) {
                              // ignore: always_specify_types
                              restService.addMembersRequest(
                                  project!.projectId, <String, dynamic>{
                                "workerIds": newMembers.join(',')
                              }).then((bool requestSuccessful) {
                                if (requestSuccessful) {
                                  project!.members
                                      .addAll(contentController.getTaggedUsers);
                                  contentController.clearInputs();

                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          }

                          if (layoutOption == ConnectionsLayoutOptions.send) {
                            //TODO: Send message to group chat
                          }
                        },
                        child: layoutOption == ConnectionsLayoutOptions.add
                            ? const Text('Add')
                            : const Text('Send'))
                    : const SizedBox()
              ]),
          SizedBox(
              height: screenHeight * .27,
              child: GridView.builder(
                  itemCount: restService.getUserConnections.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisCount: 4,
                      childAspectRatio: 1.5),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(children: <Widget>[
                      ElevatedButton(
                          onLongPress: () {
                            if (layoutOption == ConnectionsLayoutOptions.chat) {
                              tagUserConnection(context, index);
                              //TODO: Implement initiating group chat
                            }
                          },
                          onPressed: () {
                            if (layoutOption == ConnectionsLayoutOptions.tag) {
                              tagUserConnection(context, index);
                            }
                            if (layoutOption == ConnectionsLayoutOptions.chat) {
                              chatWithConnection(context,
                                  restService.getUserConnections[index].userId);
                            }
                            if (layoutOption == ConnectionsLayoutOptions.send) {
                              sendPrivateMessage(
                                  context,
                                  getChat(
                                      context,
                                      restService
                                          .getUserConnections[index].userId),
                                  message: shareLink);
                              Navigator.pop(context);
                            }

                            if (layoutOption == ConnectionsLayoutOptions.add) {
                              tagUserConnection(context, index);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder()),
                          child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black,
                              backgroundImage:  AssetImage(
                                      'assets/images/profile_placeholder.png'))),
                      if (layoutOption == ConnectionsLayoutOptions.tag ||
                          layoutOption == ConnectionsLayoutOptions.add)
                        toggleTaggedMark(context, index)
                    ]);
                  }))
        ]));
  }
}
