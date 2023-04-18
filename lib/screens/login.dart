import 'package:colabs_mobile/components/authenticate.dart';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.only(top: screenHeight * .2),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        const Authenticate(),
        Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(children: <Widget>[
                TextFormField(
                  validator: (String? value) => value!.isEmpty ? "Enter your username" : null,
                    decoration: const InputDecoration(label: Text('Username'))),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (String? value) =>
                        value!.isEmpty ? "Enter your password" : null,
                  obscureText: true,
                    decoration: const InputDecoration(label: Text('Password'))),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () async {
                      bool isValid = formKey.currentState!.validate();

                      if (!isValid) return;
                      formKey.currentState!.save();
                    },
                    child: const Text('Log In'))
              ]),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Don't have an account yet? "),
            InkWell(
                child: const Text('Sign Up',
                    style: TextStyle(fontSize: 17, color: Colors.blueAccent)),
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                })
          ],
        ),
        const SizedBox(height: 50)
      ]),
    ));
  }
}
