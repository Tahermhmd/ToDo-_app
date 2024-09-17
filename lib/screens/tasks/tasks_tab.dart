import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/my_provider.dart';
import 'package:to_do_app/screens/tasks/task_item.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';
import 'package:to_do_app/shared/styles/app_colors.dart';

import '../../models/tasks_model.dart';

class TasksTab extends StatefulWidget {
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  DateTime selectedDate = DateTime.now();
  late MyProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)),
            onDateSelected: (date) {
              selectedDate = date;
              setState(() {});
            },
            leftMargin: 20,
            monthColor: AppColors.primaryColor,
            dayColor: provider.isDarkMode()
                ? AppColors.primaryColor
                : AppColors.white,
            activeDayColor: AppColors.white,
            activeBackgroundDayColor: AppColors.primaryColor,
            dotsColor: AppColors.white,
            selectableDayPredicate: (date) => true,
            //If I want to unlock clicking on a specific day
            locale: 'en_ISO',
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<TasksModel>>(
            stream: FirebaseManager.getTask(selectedDate),
            builder: (context, snapshot) {
              //if the data were delayed
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              //if there was an error in getting the data
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
              //neither happened then data is retrieved successfully
              var tasks =
                  snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TaskItem(
                    task: tasks[index],
                  );
                },
                itemCount: tasks.length,
              );
            },
          ))
        ],
      ),
    );
  }
}
