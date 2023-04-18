import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Authenticator authenticator = Provider.of<Authenticator>(context);

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                authenticator.setAccessToken = await authenticator.getGoogleToken();
              },
              child: Row(children: const <Widget>[SizedBox(), Text('Google')])),
          ElevatedButton(
              onPressed: () async {
                authenticator.setAccessToken = await authenticator.getGithubToken();
              },
              child: Row(children: const <Widget>[SizedBox(), Text('Github')])),
          const SizedBox(height: 30),
          const Divider(thickness: 5),
          Form(
              key: formKey,
              child: Column(children: <Widget>[
                TextFormField(
                    decoration: const InputDecoration(label: Text('Username'))),
                TextFormField(
                    decoration: const InputDecoration(label: Text('Password'))),
                ElevatedButton(
                    onPressed: () async {
                      bool isValid = formKey.currentState!.validate();

                      if (!isValid) return;
                      formKey.currentState!.save();
                    },
                    child: const Text('Login'))
              ])),
          Row(
            children: <Widget>[
              const Text('If you do not have an account go to '),
              InkWell(
                  child: const Text('Signup Here', style: TextStyle(fontSize: 17)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/signup');
                  })
            ],
          )
        ]));
  }
}
