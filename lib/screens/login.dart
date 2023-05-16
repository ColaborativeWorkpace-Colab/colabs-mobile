import 'package:colabs_mobile/components/authenticate.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: screenHeight * .15),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 10),
                      blurRadius: 5)
                ]),
            child: Column(children: <Widget>[
              const Authenticate(),
              Form(
                  key: formKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Column(children: <Widget>[
                      TextFormField(
                          validator: (String? value) =>
                              value!.isEmpty ? "Enter your username" : null,
                          decoration:
                              const InputDecoration(label: Text('Username'))),
                      const SizedBox(height: 15),
                      TextFormField(
                          validator: (String? value) =>
                              value!.isEmpty ? "Enter your password" : null,
                          obscureText: true,
                          decoration:
                              const InputDecoration(label: Text('Password'))),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          onPressed: () {
                            bool isValid = formKey.currentState!.validate();

                            if (!isValid) return;
                            formKey.currentState!.save();

                            //TODO: Save an info if necessary
                            Navigator.popUntil(
                              context,
                              ModalRoute.withName('/'),
                            );
                          },
                          child: const Text('Log In'))
                    ])
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account yet? "),
                  InkWell(
                      child: const Text('Sign Up',
                          style: TextStyle(
                              fontSize: 17, color: Colors.blueAccent)),
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      })
                ]
              ),
              const SizedBox(height: 50)
            ])
          )
        ));
  }
}
