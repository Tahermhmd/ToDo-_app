import 'package:flutter/material.dart';
import 'package:to_do_app/screens/login/login_screen.dart';
import 'package:to_do_app/screens/sign_up/signup_screen.dart';
import 'package:to_do_app/shared/styles/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  static String routeName = "register Screen";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo App"),
          bottom: TabBar(
            indicatorColor: AppColors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.login_rounded),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.app_registration_rounded),
                text: "SignUp",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LoginScreen(),
            SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
