import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/screens/motivation.dart';
import 'package:todo/screens/task_view.dart';
import 'package:todo/task_adapter.dart';
import 'package:todo/provider/task_provider.dart';

import '../constants.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
        builder: (BuildContext context, taskProvider, _) {
      return Drawer(
        child: ListView(
          children: [
            DecoratedBox(
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: SizedBox(
                  height: 60,
                  child: ListTile(
                    onTap: () {},
                    leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    title: const Text(
                      "TODO List",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: taskProvider.savedTask.length,
                itemBuilder: (BuildContext context, index) {
                  TaskAdapter data = taskProvider.savedTask.getAt(index);
                  return ListTile(
                    onTap: () {
                      taskProvider.taskForm =
                          taskProvider.savedTask.getAt(index);
                      taskProvider.setIndex(index);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const TaskView())));
                    },
                    title: Text(data.title ?? "No Title"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        taskProvider.savedTask.deleteAt(index);
                        taskProvider.notify();
                      },
                    ),
                  );
                }),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MotivationScreen())),
              leading: const Icon(Icons.warning_amber, color: Colors.redAccent),
              title: const Text("MOTIVATE ME",
                  style: TextStyle(color: Colors.redAccent)),
            )
          ],
        ),
      );
    });
  }
}
