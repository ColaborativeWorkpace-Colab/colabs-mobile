import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  //Navigator.pushNamed(context, ModalRoute.withName('/settings'));
                },
                icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/login'));
                },
                icon: const Icon(Icons.logout_rounded))
          ],
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Stack(children: <Widget>[
            SizedBox(height: screenHeight * .31),
            Positioned(
              child: Image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: screenHeight * .25,
                  image: const AssetImage('assets/images/placeholder.png')),
            ),
            const Positioned(
                left: 30,
                bottom: 1,
                child: Hero(
                    tag: 'ProfileTag',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                    )))
          ])
        ])));
  }
}
