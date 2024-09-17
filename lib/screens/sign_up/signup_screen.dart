import 'package:flutter/material.dart';
import 'package:to_do_app/layout/home_layout.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "Signup Screen";
  var _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    "Sign up",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ), //styling
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (value) {},
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid name!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      //Validator
                    },
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
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  //text input
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    keyboardType: TextInputType.visiblePassword,
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
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    onFieldSubmitted: (value) {},
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid phone number!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),

                  ElevatedButton(
                    style: ButtonStyle(

                        /*padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),*/
                        ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    onPressed: () {
                      FirebaseManager.createAccount(
                          nameController.text,
                          phoneController.text,
                          emailController.text,
                          passwordController.text, () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeLayout.routeName, (route) => false);
                      }, (error) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(error.toString()),
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

  var isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
  }
}
