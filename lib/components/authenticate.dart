import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/utils/initialize_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Authenticator authenticator = Provider.of<Authenticator>(context);

    return Column(
      children: <Widget>[
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                //FIXME: Revert to original
                // authenticator.setAccessToken =
                //     await authenticator.getGoogleToken();

                initServices(context);
                Navigator.pushNamed(context, '/');
              },
              child: Row(children: const <Widget>[
                Image(
                    height: 40, image: AssetImage('assets/images/google.png')),
                SizedBox(width: 50),
                Text('Continue with Google',
                    style: TextStyle(color: Colors.white))
              ])),
        ),
        Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  //FIXME: Revert to original
                  authenticator.getGithubToken().then((value) {
                    initServices(context);
                    authenticator.setIsAuthorized = true;
                  });
                },
                child: Row(children: const <Widget>[
                  Image(image: AssetImage('assets/images/github.png')),
                  SizedBox(width: 50),
                  Text('Continue with Github',
                      style: TextStyle(color: Colors.black))
                ]))),
        const SizedBox(height: 30),
        Stack(children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Divider(thickness: 2.5)),
          Positioned(
              left: screenWidth * .37,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: const Text('OR',
                      style: TextStyle(color: Colors.grey, fontSize: 15))))
        ]),
      ],
    );
  }
}
