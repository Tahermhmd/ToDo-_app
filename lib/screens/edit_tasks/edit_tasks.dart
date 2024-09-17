import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/layout/home_layout.dart';

import '../../models/tasks_model.dart';
import '../../shared/network/firebase/firebase_manager.dart';
import '../../shared/styles/app_colors.dart';

class EditTask extends StatefulWidget {
  static String routeName = "Edit Screen";
  DateTime chosenDate = DateTime.now();

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var titleEditController = TextEditingController();

  var descriptionEditController = TextEditingController();

  var chosenDateEdit = DateTime.now();

  late TasksModel task;

  @override
  Widget build(BuildContext context) {
    task = ModalRoute.of(context)?.settings.arguments as TasksModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Task",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.black, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          Text("Edit Task",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.black, fontSize: 22)
              /*TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor)*/
              ),
          TextField(
            controller: titleEditController,
            decoration: InputDecoration(
                label: Text("Task Title",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.black, fontSize: 22)
                    /*TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)*/
                    ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor))),
          ),
          SizedBox(
            height: 18,
          ),
          TextField(
            controller: descriptionEditController,
            decoration: InputDecoration(
                label: Text("Task Description",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.black, fontSize: 22)
                    /*TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)*/
                    ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor))),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              selectDate();
            },
            child: Text(chosenDateEdit.toString().substring(0, 10),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.black)),
          ),
          ElevatedButton(
              onPressed: () {
                task = TasksModel(
                    id: task.id,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    title: titleEditController.text,
                    description: descriptionEditController.text,
                    date: DateUtils.dateOnly(chosenDateEdit)
                        .millisecondsSinceEpoch);
                /*task.title = titleEditController.text;
            task.description = descriptionEditController.text;
            task.date = DateUtils.dateOnly(chosenDateEdit).millisecondsSinceEpoch;*/
                FirebaseManager.editTask(task).then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeLayout()));
                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(
                "Save Changes",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.black, fontSize: 22),
              )),
        ],
      ),
    );
  }

  void selectDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: chosenDateEdit,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (selectedDate == null) {
      //it will be null when pressed on cancel
      return;
    }
    chosenDateEdit = selectedDate;
    setState(() {});
  }
}
