import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/task_provider.dart';

class TaskView extends StatelessWidget {
  final index;
  const TaskView({required this.index ,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (BuildContext context, taskProvider, child) => Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: taskProvider.savedTask.getAt(index).title
      ),
    ));
  }
}
