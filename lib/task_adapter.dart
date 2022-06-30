import 'package:hive/hive.dart';

part 'task_adapter.g.dart';

@HiveType(typeId: 0)
class TaskAdapter {
  @HiveField(0)
  String? title;
  @HiveField(1)
  bool? completed = false;
  @HiveField(2)
  List<String?> subTasks = [];
  @HiveField(3)
  List<bool> isDone = [];
  TaskAdapter(
      {this.title,
      this.completed,
      required this.subTasks,
      required this.isDone});
}
