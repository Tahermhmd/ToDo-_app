import 'package:flutter/material.dart';
import 'package:to_do_app/screens/settings/settings.dart';
import 'package:to_do_app/screens/tasks/add_tasks_bottom_sheet.dart';
import 'package:to_do_app/screens/tasks/tasks_tab.dart';
import 'package:to_do_app/shared/styles/app_colors.dart';

class HomeLayout extends StatefulWidget {

  static const String routeName = "Home Layout";

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int index = 0;
  List<Widget> tabs = [TasksTab(),SettingsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("ToDo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddTasksBottomSheet();
        },
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: AppColors.white,
            width: 3
          )
        ),
        child: Icon(Icons.add,size: 30,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 12,
        color: AppColors.white,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.hardEdge,
        child: BottomNavigationBar(
          //backgroundColor: AppColors.transparent,
          elevation: 0,
          currentIndex: index,
          onTap: (value){
            index = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem( icon: Icon(Icons.list),label: ""),
            BottomNavigationBarItem( icon: Icon(Icons.settings),label: ""),
          ],
        ),
      ),
      body: tabs[index],
    );
  }

  void showAddTasksBottomSheet() {
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        builder: (context){
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddTaskBottomSheet());
    });
  }
}

