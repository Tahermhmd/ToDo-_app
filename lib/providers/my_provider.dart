import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/preference/my_preference.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';

class MyProvider extends ChangeNotifier {
  UserModel? userModel;
  User? userFirebase;

  ThemeMode currentTheme = ThemeMode.light;

  MyProvider() {
    userFirebase = FirebaseAuth.instance
        .currentUser; // current user is of a type user that's why we made userFirebase of type user
    if (userFirebase != null) {
      // if i found the current user null => no user logs in so != null a user has logged in
      initUser();
    }
  }

  initUser() async {
    userFirebase = FirebaseAuth
        .instance.currentUser; // to make sure that the user will enter ???
    userModel = await FirebaseManager.readUser(userFirebase!
        .uid); // I want to compare between the userid from firestore and the entered one
    String? mode = MyPreference.getMode();
    if (mode == "dark") {
      setCurrentTheme(ThemeMode.dark);
    } else {
      setCurrentTheme(ThemeMode.light);
    }
    notifyListeners();
  }

  void setCurrentTheme(ThemeMode newTheme) {
    currentTheme = newTheme;
    if (newTheme == "dark") {
      MyPreference.saveMode("dark");
    } else {
      MyPreference.saveMode("light");
    }
    notifyListeners();
  }

  bool isDarkMode() => currentTheme == ThemeMode.dark;
}
