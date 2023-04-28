import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    LayoutController layoutController = Provider.of<LayoutController>(context);

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text('Log Out'),
                            content:
                                const Text('Are you sure you want to log out?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.redAccent)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/login'));
                                  })
                            ]);
                      });
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
            Positioned(
                left: 30,
                bottom: 1,
                child: Hero(
                    tag: 'ProfileTag${layoutController.getSearchFilter.name}',
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                    )))
          ]),
          const Text('Bio'),
          const Text('Interests'),
          const Text('Skills'),
        ])));
  }
}
