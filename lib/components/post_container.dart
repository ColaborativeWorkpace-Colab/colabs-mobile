import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        height: screenHeight * .62,
        width: screenWidth * .95,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(7)),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Container(
                margin: const EdgeInsets.all(10),
                child: const CircleAvatar(
                    radius: 25, backgroundColor: Colors.black)),
            Column(children: const <Widget>[
              Text('User Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Occupation', style: TextStyle(fontSize: 10)),
              Text('24/4/2023',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10))
            ])
          ]),
          Image(
              fit: BoxFit.cover,
              height: screenHeight * .4,
              image: const AssetImage('assets/images/placeholder.png')),
          const SizedBox(height: 30),
          Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(height: 1, color: Colors.black)),
          Row(children: <Widget>[
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.thumb_up_alt_rounded))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.comment))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.share))),
            SizedBox(
                height: 50,
                width: screenWidth * .25,
                child: ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.send)))
          ])
        ]));
  }
}
