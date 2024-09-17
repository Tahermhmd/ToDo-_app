import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/my_provider.dart';
import 'package:to_do_app/screens/register/register_screen.dart';

import '../../shared/styles/app_colors.dart';

class SettingsTab extends StatelessWidget {
  bool darkModeSwitch = false;
  late MyProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Settings",
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("Dark Mode"),
                Spacer(),
                Switch(
                  value: darkModeSwitch,
                  onChanged: (newValue) {
                    if (newValue) {
                      provider.setCurrentTheme(ThemeMode.dark);
                      darkModeSwitch = newValue;
                    } else if (!newValue) {
                      provider.setCurrentTheme(ThemeMode.light);
                      darkModeSwitch = newValue;
                    }
                  },
                  activeColor: AppColors.primaryColor,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, RegisterScreen.routeName, (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text("Log Out"),
                  Spacer(),
                  Icon(
                    Icons.logout_rounded,
                    color: provider.isDarkMode()
                        ? AppColors.white
                        : AppColors.primaryColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
