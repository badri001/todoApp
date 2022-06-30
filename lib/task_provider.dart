import 'package:flutter/material.dart';
import 'package:todo/task_adapter.dart';

class TaskProvider with ChangeNotifier {
  TaskAdapter newTask = TaskAdapter(subTasks: [], isDone: []);
  var savedTask;

  notify() {
    notifyListeners();
  }

  addSubTask() {
    newTask.subTasks.add("");
    newTask.isDone.add(false);
  }

  clear() {
    newTask = TaskAdapter(subTasks: [], isDone: [], title: "");
    notifyListeners();
  }
}
