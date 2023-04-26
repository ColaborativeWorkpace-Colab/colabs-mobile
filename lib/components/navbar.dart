import 'package:flutter/material.dart';

enum SearchFilter { social, project, job, message }

extension SearchExtension on SearchFilter {
  String get name {
    switch (this) {
      case SearchFilter.job:
        return 'Jobs';
      case SearchFilter.project:
        return 'Projects';
      case SearchFilter.message:
        return 'Messages';
      default:
        return '';
    }
  }
}

class Navbar extends StatelessWidget {
  final SearchFilter searchFilter;
  const Navbar({super.key, required this.searchFilter});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(left: 25, top: 15, bottom: 20),
      child: Row(children: <Widget>[
        SizedBox(
            height: 50,
            width: screenWidth * .75,
            child: TextField(
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    suffixIcon: IconButton(
                        onPressed: () {
                          switch (searchFilter) {
                            case SearchFilter.social:
                              break;
                            case SearchFilter.message:
                              break;
                            case SearchFilter.project:
                              break;
                            case SearchFilter.job:
                              break;
                          }
                        },
                        icon: const Icon(Icons.search_rounded)),
                    hintText: 'Search ${searchFilter.name}',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(45)))))),
        //FIXME: Fix bug with different search bars concerning hero tag
        Hero(
          tag: 'ProfileTag',
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
            ),
          ),
        )
      ]),
    );
  }
}
