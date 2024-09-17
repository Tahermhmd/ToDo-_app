import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/layout/home_layout.dart';
import 'package:to_do_app/providers/my_provider.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';

class LoginScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  late MyProvider provider;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            //form
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Log in",
                    style:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ), //styling
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                  ),
                  //box styling
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  //text input
                  TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value) {},
                      obscureText: true,
                      validator: (value) {
                        RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        if (value!.isEmpty) {
                          return 'Please enter password';
                        } else {
                          if (!regex.hasMatch(value)) {
                            return 'Enter valid password';
                          } else {
                            return null;
                          }
                        }
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),

                  ElevatedButton(
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    onPressed: () {
                      FirebaseManager.login(
                          emailController.text, passwordController.text, () {
                        provider.initUser();
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeLayout.routeName, (route) => false);
                      }, (message) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text(message),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Ok"))
                              ],
                            ));
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
