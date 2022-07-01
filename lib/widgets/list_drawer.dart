import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/task_view.dart';
import 'package:todo/task_adapter.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/task_model.dart';

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
            // const ListTile(
            //   title: Text("list 1"),
            // ),
            // const ListTile(
            //   title: Text("list 2"),
            // ),
            // const ListTile(
            //   title: Text("list 3"),
            // ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: taskProvider.savedTask.length,
                itemBuilder: (BuildContext context, index) {
                  TaskAdapter data = taskProvider.savedTask.getAt(index);
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskView(data: data)));
                    },
                    title: Text(data.title ?? "No Title"),
                    subtitle: Text("has ${data.subTasks.length} subtasks"),
                  );
                }),

            ///close tile
            ListTile(
              onTap: () => Navigator.pop(context),
              title:
                  const Text("Close", style: TextStyle(color: kPrimaryColor)),
            )
          ],
        ),
      );
    });
  }
}
