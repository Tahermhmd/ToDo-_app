import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/tasks_model.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';
import 'package:to_do_app/shared/styles/app_colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var titleController = TextEditingController();

  var descriptionController = TextEditingController();

  var chosenDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Add New Task",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: AppColors.black, fontSize: 22),
          ),
          SizedBox(
            height: 24,
          ),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
                label: Text("Task Title",
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
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
                label: Text("Task Description",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
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
          Text("Select Date",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.black, fontSize: 20)),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              selectDate();
            },
            child: Text(chosenDate.toString().substring(0, 10),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.black)),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                TasksModel task = TasksModel(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    title: titleController.text,
                    description: descriptionController.text,
                    date:
                        DateUtils.dateOnly(chosenDate).millisecondsSinceEpoch);
                FirebaseManager.addTask(task).then((value) {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(
                "Add Task",
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
        initialDate: chosenDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (selectedDate == null) {
      //it will be null when pressed on cancel
      return;
    }
    chosenDate = selectedDate;
    setState(() {});
  }
}
