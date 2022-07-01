import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/task_adapter.dart';
import 'package:todo/task_model.dart';

class TaskView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final int index;
  const TaskView({required this.index, Key? key}) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var subTasks = <TextEditingController>[];
  late List<bool> isDone;

  forEach(TaskAdapter data) {
    subTasks.add(TextEditingController());
    subTasks.last.text = data.subTasks.toString();
    isDone = data.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
        builder: (BuildContext context, taskProvider, _) {
      final TaskAdapter data = taskProvider.savedTask.getAt(widget.index);
      return Scaffold(
        appBar: AppBar(
          title: Text(data.title ?? "No title"),
        ),
      );
    });
  }
}

// /task?id=4
// /task/4