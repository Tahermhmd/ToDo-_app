import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/tasks_model.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';
import 'package:to_do_app/shared/styles/app_colors.dart';

import '../edit_tasks/edit_tasks.dart';

class TaskItem extends StatefulWidget {
  TasksModel task;

  TaskItem({required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.transparent,
        ),
      ),
      child: Slidable(
        closeOnScroll: true,
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                FirebaseManager.deleteTask(widget.task.id);
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                Navigator.pushNamed(context, EditTask.routeName,
                    arguments: widget.task);
              },
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // Use Column as the parent
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 4,
                    decoration: BoxDecoration(
                      color: provider.isDarkMode()
                          ? AppColors.backgroundDarkColor
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          widget.task.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      FirebaseManager.updateFinishedTasks(widget.task.id, true);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                      decoration: BoxDecoration(
                        color: widget.task.isDone
                            ? AppColors.green
                            : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.task.isDone
                          ? Text(
                        "Done!",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: AppColors.white, fontSize: 18),
                            )
                          : Icon(Icons.done, color: AppColors.white, size: 30),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
