import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditForm extends StatefulWidget {
  final Map<String, dynamic> profileInfo;
  const ProfileEditForm({super.key, required this.profileInfo});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? fullNameController;
  TextEditingController? occupationController;
  TextEditingController? locationController;
  TextEditingController? bioController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(
        text:
            '${widget.profileInfo['firstName']} ${widget.profileInfo['lastName']}');
    occupationController =
        TextEditingController(text: widget.profileInfo['occupation']);
    locationController =
        TextEditingController(text: widget.profileInfo['location']);
    bioController = TextEditingController(text: widget.profileInfo['bio']);
  }

  @override
  Widget build(BuildContext context) {
    RESTService restService = Provider.of<RESTService>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        title: const Text('Edit Profile Info'),
        content: SizedBox(
            height: screenHeight * .5,
            width: screenWidth,
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Empty field';
                            }
                            if (value.split(' ').length != 2) {
                              return 'Enter first and last name';
                            }
                            return null;
                          },
                          controller: fullNameController,
                          decoration: const InputDecoration(
                              label: Text('Full Name'),
                              border: OutlineInputBorder()))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Empty field';
                            }
                            return null;
                          },
                          controller: occupationController,
                          decoration: const InputDecoration(
                              label: Text('Occupation'),
                              border: OutlineInputBorder()))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                              label: Text('Location'),
                              border: OutlineInputBorder()))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          controller: bioController,
                          minLines: 5,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              label: Text('Bio'),
                              border: OutlineInputBorder())))
                ])))),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                bool isValid = formKey.currentState!.validate();

                if (!isValid) return;
                formKey.currentState!.save();

                List<String> fullName = fullNameController!.text.split(' ');
                // ignore: always_specify_types
                Map<String, dynamic> updatedProfileInfo = {
                  'firstName': fullName[0],
                  'lastName': fullName[1],
                  'occupation': occupationController!.text,
                  'location': locationController!.text,
                  'bio': bioController!.text
                };
                restService
                    // ignore: always_specify_types
                    .editProfileRequest(updatedProfileInfo)
                    .timeout(const Duration(seconds: 10))
                    .then((bool requestSuccessful) {
                  if (requestSuccessful) {
                    restService.updateProfileInfo(updatedProfileInfo);
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text('Done'))
        ]);
  }
}
