import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/task_adapter.dart';

class TaskProvider with ChangeNotifier {
  TaskAdapter taskForm = TaskAdapter(subTasks: [], isDone: []);
  var savedTask;
  int formIndex = 0;
  notify() {
    notifyListeners();
  }

  setIndex(int index) {
    formIndex = index;
    notifyListeners();
  }

  getSaveTask() async {
    // print(savedTask.runtimeType);
    savedTask = await Hive.openBox('myTasks');
    notifyListeners();
  }

  addSubTask() {
    taskForm.subTasks.add("");
    taskForm.isDone.add(false);
  }

  clear() {
    taskForm = TaskAdapter(subTasks: [], isDone: [], title: "");
    notifyListeners();
  }
}
