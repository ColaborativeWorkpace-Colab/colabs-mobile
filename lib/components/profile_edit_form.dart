import 'package:flutter/material.dart';

class ProfileEditForm extends StatelessWidget {
  ProfileEditForm({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        title: const Text('Edit Profile Info'),
        content: SizedBox(
            height: screenHeight * .41,
            width: screenWidth,
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              label: Text('Full Name'),
                              border: OutlineInputBorder())),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              label: Text('Occupation'),
                              border: OutlineInputBorder())),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              label: Text('Location'),
                              border: OutlineInputBorder())),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              label: Text('Bio'),
                              border: OutlineInputBorder())),
                    )
                  ]),
                ))),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                //TODO: Edit profile
              },
              child: const Text('Done'))
        ]);
  }
}
