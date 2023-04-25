import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

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
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search_rounded)),
                    hintText: 'Search',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(45)))))),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
          ),
        )
      ]),
    );
  }
}
