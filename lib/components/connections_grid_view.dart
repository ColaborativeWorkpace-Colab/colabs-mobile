import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:colabs_mobile/utils/connection_view_functions.dart';
import 'package:colabs_mobile/utils/send_private_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionsGridView extends StatelessWidget {
  final ConnectionsLayoutOptions layoutOption;
  final String? shareLink;
  const ConnectionsGridView(
      {super.key, required this.layoutOption, this.shareLink});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    RESTService restService = Provider.of<RESTService>(context);

    return Container(
        margin: const EdgeInsets.all(10),
        height: screenHeight * .4,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Text(layoutOption.name, style: const TextStyle(fontSize: 17)),
          Row(
            children: <Widget>[
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  height: 50,
                  width: layoutOption == ConnectionsLayoutOptions.send ||
                          layoutOption == ConnectionsLayoutOptions.add
                      ? screenWidth * .72
                      : screenWidth * .92,
                  child: TextField(
                      onChanged: (String value) {
                        //TODO: When searching, auto filter while typing for user
                      },
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search_rounded)),
                          hintText: 'Search Connections',
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)))))),
              layoutOption == ConnectionsLayoutOptions.send ||
                      layoutOption == ConnectionsLayoutOptions.add
                  ? ElevatedButton(
                      onPressed: () {
                        //TODO: Add members or send message to group chat
                      },
                      child: layoutOption == ConnectionsLayoutOptions.add
                          ? const Text('Add')
                          : const Text('Send'))
                  : const SizedBox()
            ],
          ),
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
                              //TODO: Add teammates
                              tagUserConnection(context, index);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder()),
                          child: const CircleAvatar(
                              radius: 50, backgroundColor: Colors.black)),
                      if (layoutOption == ConnectionsLayoutOptions.tag)
                        toggleTaggedMark(context, index)
                    ]);
                  }))
        ]));
  }
}
