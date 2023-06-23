import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget {
  final SearchFilter searchFilter;
  const Navbar({super.key, required this.searchFilter});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    RESTService restService = Provider.of<RESTService>(context);

    return Container(
        margin: const EdgeInsets.only(left: 25, top: 15),
        child: Row(children: <Widget>[
          SizedBox(
              height: 50,
              width: screenWidth * .68,
              child: TextField(
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      suffixIcon: IconButton(
                          onPressed: () {
                            switch (searchFilter) {
                              case SearchFilter.social:
                                //TODO: Go to explore page
                                //TODO: Search Connections
                                break;
                              case SearchFilter.message:
                                //TODO: Search messages
                                //TODO: Search Connections
                                break;
                              case SearchFilter.project:
                                //TODO: Search projects
                                break;
                              case SearchFilter.job:
                                //TODO: Search job
                                break;
                              case SearchFilter.post:
                                break;
                            }
                          },
                          icon: const Icon(Icons.search_rounded)),
                      hintText: 'Search ${searchFilter.name}',
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(45)))))),
          Hero(
              tag: 'ProfileTag${searchFilter.name}',
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          restService.getProfileInfo['imageUrl'] != null
                              ? Image.network(
                                      restService.getProfileInfo['imageUrl'])
                                  .image
                              : const AssetImage(
                                  'assets/images/profile_placeholder.png'))))
        ]));
  }
}
