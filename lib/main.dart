import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/layout/home_layout.dart';
import 'package:to_do_app/preference/my_preference.dart';
import 'package:to_do_app/providers/my_provider.dart';
import 'package:to_do_app/screens/edit_tasks/edit_tasks.dart';
import 'package:to_do_app/screens/register/register_screen.dart';
import 'package:to_do_app/shared/styles/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyPreference.pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FirebaseFirestore.instance.disableNetwork();
  runApp(ChangeNotifierProvider(
      create: (context) => MyProvider(), child: MyApp()));
}

late MyProvider provider;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: provider.userFirebase != null
          ? HomeLayout.routeName
          : RegisterScreen.routeName,
      routes: {
        HomeLayout.routeName: (_) => HomeLayout(),
        EditTask.routeName: (_) => EditTask(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
      },
      themeMode: provider.currentTheme,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
