import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionsGridView extends StatelessWidget {
  final String title;
  const ConnectionsGridView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    RESTService restService = Provider.of<RESTService>(context);
    ContentController contentController =
        Provider.of<ContentController>(context);

    return Container(
        margin: const EdgeInsets.all(10),
        height: screenHeight * .4,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: const TextStyle(fontSize: 17)),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height: 50,
                  width: screenWidth * .95,
                  child: TextField(
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
              //TODO: get user connections
              SizedBox(
                  height: screenHeight * .27,
                  child: GridView.builder(
                      itemCount: restService.getUserConnections.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisCount: 4,
                              childAspectRatio: 1.5),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(children: <Widget>[
                          ElevatedButton(
                              onPressed: () async {
                                (!contentController.getTaggedUsers.contains(
                                        restService.getUserConnections[index]))
                                    ? contentController.tagUser(
                                        restService.getUserConnections[index])
                                    : contentController.untagUser(
                                        restService.getUserConnections[index]);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder()),
                              child: const CircleAvatar(
                                  radius: 50, backgroundColor: Colors.black)),
                          (contentController.getTaggedUsers.contains(
                                  restService.getUserConnections[index]))
                              ? const Positioned(
                                  bottom: 1,
                                  right: 5,
                                  child: Icon(Icons.check_circle,
                                      color: Colors.indigoAccent),
                                )
                              : const SizedBox()
                        ]);
                      }))
            ]));
  }
}
