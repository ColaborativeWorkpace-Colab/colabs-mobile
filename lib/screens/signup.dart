import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/types/user_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Authenticator authenticator = Provider.of<Authenticator>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                  color: Colors.black12, offset: Offset(0, 10), blurRadius: 5)
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Form(
              key: formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Column(children: <Widget>[
                  TextFormField(
                      controller: firstNameController,
                      validator: (String? value) =>
                          value!.isEmpty ? "Enter your first name" : null,
                      decoration:
                          const InputDecoration(label: Text('First Name'))),
                  const SizedBox(height: 15),
                  TextFormField(
                      controller: lastNameController,
                      validator: (String? value) =>
                          value!.isEmpty ? "Enter your last name" : null,
                      decoration:
                          const InputDecoration(label: Text('Last Name'))),
                  const SizedBox(height: 15),
                  TextFormField(
                      controller: emailController,
                      validator: (String? value) => value!.isEmpty
                          ? "Enter your email"
                          : !value.contains(RegExp(
                                  r"/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/"))
                              ? "Invalid email format"
                              : null,
                      decoration: const InputDecoration(label: Text('Email'))),
                  const SizedBox(height: 15),
                  TextFormField(
                      controller: passwordController,
                      validator: (String? value) =>
                          value!.isEmpty ? "Enter your password" : null,
                      decoration:
                          const InputDecoration(label: Text('Password'))),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    child: Row(children: <Widget>[
                      SizedBox(
                        width: screenWidth * .4,
                        height: 50,
                        child: ListTile(
                          horizontalTitleGap: 1,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Freelancer',
                              style: TextStyle(fontSize: 13)),
                          leading: Radio<UserType?>(
                            value: authenticator.getUserType,
                            groupValue: UserType.freelancer,
                            onChanged: (UserType? value) {
                              authenticator.setUserType = UserType.freelancer;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * .35,
                        height: 50,
                        child: ListTile(
                            horizontalTitleGap: 1,
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Recruiter',
                                style: TextStyle(fontSize: 13)),
                            leading: Radio<UserType?>(
                                value: authenticator.getUserType,
                                groupValue: UserType.recruiter,
                                onChanged: (UserType? value) {
                                  authenticator.setUserType =
                                      UserType.recruiter;
                                })),
                      )
                    ]),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: authenticator.hasUserAgreed,
                          onChanged: (bool? value) {
                            authenticator.setHasUserAgreed = value!;
                          }),
                      SizedBox(
                        width: screenWidth * .55,
                        child: const Text(
                            "Yes, I understand and agree to the Colabs Terms of Service."),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        bool isValid = formKey.currentState!.validate();

                        if (!isValid) return;
                        formKey.currentState!.save();

                        authenticator.register(<String, dynamic>{
                          "firstName": firstNameController.text,
                          "lastName": lastNameController.text,
                          "email": emailController.text,
                          "password": passwordController.text
                        }, authenticator.getUserType.name);

                        //TODO: Save an info if necessary
                        // Navigator.popUntil(
                        //   context,
                        //   ModalRoute.withName('/'),
                        // );
                      },
                      child: const Text('Sign Up'))
                ]),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already have an account? "),
              InkWell(
                  child: const Text('Log In',
                      style: TextStyle(fontSize: 17, color: Colors.blueAccent)),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ]
          ),
          const SizedBox(height: 50)
        ])
      )
    ));
  }
}
