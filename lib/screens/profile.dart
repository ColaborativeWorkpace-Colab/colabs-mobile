import 'package:colabs_mobile/components/profile_edit_form.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/project_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    LayoutController layoutController = Provider.of<LayoutController>(context);
    ChatController chatController = Provider.of<ChatController>(context);
    Authenticator authenticator = Provider.of<Authenticator>(context);
    RESTService restService = Provider.of<RESTService>(context);
    ProjectController projectController =
        Provider.of<ProjectController>(context);

    return Scaffold(
        appBar: AppBar(actions: <Widget>[
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
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                                child: const Text('Logout',
                                    style: TextStyle(color: Colors.redAccent)),
                                onPressed: () {
                                  chatController.disconnect();
                                  layoutController.loggingOut();
                                  authenticator.setIsAuthorized = false;
                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/login'));
                                })
                          ]);
                    });
              },
              icon: const Icon(Icons.logout_rounded))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileEditForm(
                      profileInfo: restService.getProfileInfo,
                    );
                  });
            },
            child: const FaIcon(FontAwesomeIcons.penToSquare)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
              Stack(children: <Widget>[
                SizedBox(height: screenHeight * .31),
                Positioned(
                    child: Image(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: screenHeight * .25,
                        image:
                            const AssetImage('assets/images/placeholder.png'))),
                Positioned(
                    left: screenWidth * .38,
                    bottom: 1,
                    child: Hero(
                        tag:
                            'ProfileTag${layoutController.getSearchFilter.name}',
                        child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black,
                            backgroundImage: restService
                                        .getProfileInfo['imageUrl'] !=
                                    null
                                ? Image.network(
                                        restService.getProfileInfo['imageUrl'])
                                    .image
                                : const AssetImage(
                                    'assets/images/profile_placeholder.png'))))
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                      '${restService.getProfileInfo['firstName'] ?? ''} ${restService.getProfileInfo['lastName'] ?? ''}',
                      style: const TextStyle(fontSize: 24))),
              Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(restService.getProfileInfo['occupation'] ?? '',
                      style: const TextStyle(fontSize: 16))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(restService.getProfileInfo['location'] ?? '',
                      style: const TextStyle(fontSize: 14))),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(16),
                  child: const Text('Bio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ))),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(restService.getProfileInfo['bio'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ))),
              const SizedBox(height: 16),
              Container(
                  color: Colors.grey[200],
                  child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                          height: screenHeight * .38,
                          child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.3,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1),
                              children: <Widget>[
                                GridTile(
                                    header: Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Text('Connections',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )),
                                    ),
                                    footer: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                          restService.getUserConnections.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          )),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 228, 252)),
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/images/connections.png'),
                                          height: 50),
                                      onPressed: () {},
                                    )),
                                GridTile(
                                    header: Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Text('Projects',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )),
                                    ),
                                    footer: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                          projectController.getProjects.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          )),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 228, 252)),
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/images/projects.png'),
                                          height: 50),
                                      onPressed: () {},
                                    )),
                                GridTile(
                                    header: Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Text('Reviews',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )),
                                    ),
                                    footer: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                          (restService.getProfileInfo[
                                                      'reviews'] !=
                                                  null)
                                              ? (restService.getProfileInfo[
                                                          'reviews']
                                                      as List<dynamic>)
                                                  .length
                                                  .toString()
                                              : '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          )),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 228, 252)),
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/images/reviews.png'),
                                          height: 50),
                                      onPressed: () {},
                                    )),
                                GridTile(
                                    header: Container(
                                        alignment: Alignment.topCenter,
                                        margin: const EdgeInsets.only(top: 10),
                                        child: const Text('Jobs',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ))),
                                    footer: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                          (restService.getProfileInfo['jobs'] !=
                                                  null)
                                              ? (restService.getProfileInfo[
                                                      'jobs'] as List<dynamic>)
                                                  .length
                                                  .toString()
                                              : '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          )),
                                    ),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 237, 228, 252)),
                                        child: const Icon(Icons.work,
                                            size: 50,
                                            color: Color.fromARGB(
                                                255, 56, 22, 121)),
                                        onPressed: () {}))
                              ])))),
              const SizedBox(height: 16),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Skills',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const Center(
                                        child: Text('Acquire Skills'));
                                  });
                            },
                            icon: const Icon(Icons.add))
                      ])),
              Container(
                  padding: const EdgeInsets.all(16),
                  height: screenHeight * .3,
                  child: (restService.getProfileInfo['skills'] != null
                              ? restService.getProfileInfo['skills']
                                  as List<dynamic>
                              : <dynamic>[])
                          .isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          itemCount: (restService.getProfileInfo['skills']
                                  as List<dynamic>)
                              .length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 4,
                                  childAspectRatio: 1.5),
                          itemBuilder: (BuildContext context, int index) {
                            return const CircleAvatar();
                          })
                      : Column(children: const <Widget>[
                          Image(
                              width: 80,
                              height: 80,
                              image: AssetImage('assets/images/skills.png')),
                          SizedBox(height: 20),
                          Text(
                              '''You don't have any skills yet. Acquiring skills will make you more elgibile for employers when viewing your profile.''',
                              textAlign: TextAlign.center)
                        ]))
            ]))));
  }
}
