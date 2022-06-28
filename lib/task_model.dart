import 'package:hive/hive.dart';

class TaskModel extends HiveObject {
  String? title;
  bool completed = false;
  List<String> subTasks = [];
  List<bool> isDone = [];
}
