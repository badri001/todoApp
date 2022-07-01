import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/task_provider.dart';

import '../constants.dart';
import '../widgets/custom_snack_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  // @override
  // void dispose() {
  //   //clearTaskForm();
  //   super.dispose();
  //   clearTaskForm();
  // }
  var subTasks = <TextEditingController>[];
  bool isEdit = false;
  TextEditingController taskTitle = TextEditingController();
  void fetchTaskForm() {
    TaskProvider taskProvider = Provider.of(context, listen: false);
    taskTitle.text = taskProvider.taskForm.title!;
    for (int i = 0; i < taskProvider.taskForm.subTasks.length; i++) {
      TextEditingController temp = TextEditingController();
      temp.text = taskProvider.taskForm.subTasks[i]!;
      subTasks.add(temp);
    }
  }

  @override
  initState() {
    fetchTaskForm();
    super.initState();
  }

  clearTaskForm() {
    TaskProvider taskProvider = Provider.of(context, listen: false);
    taskProvider.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        clearTaskForm();
        return true;
      },
      child: Consumer<TaskProvider>(
        builder: (BuildContext context, taskProvider, child) => Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    clearTaskForm();
                    Navigator.pop(context);
                  }),
              title: TextField(
                enabled: isEdit,
                autofocus: isEdit,
                controller: taskTitle,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: ' Title is Mandatory',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    },
                    icon: isEdit
                        ? const Icon(Icons.check)
                        : const Icon(Icons.edit))
              ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: taskProvider.taskForm.subTasks.length,
                    itemBuilder: ((BuildContext context, index) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Checkbox(
                          value: taskProvider.taskForm.isDone[index],
                          onChanged: (bool? value) {
                            taskProvider.taskForm.isDone[index] =
                                !taskProvider.taskForm.isDone[index];
                            taskProvider.notify();
                          },
                        ),
                        title: TextField(
                          controller: subTasks[index],
                          onChanged: (value) {
                            taskProvider.taskForm.subTasks[index] = value;
                            taskProvider.notify();
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            taskProvider.taskForm.subTasks.removeAt(index);
                            taskProvider.taskForm.isDone.removeAt(index);
                            taskProvider.notify();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    })),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      subTasks.add(TextEditingController());
                      setState(() {
                        taskProvider.taskForm.subTasks.add("");
                        taskProvider.taskForm.isDone.add(false);
                      });
                      taskProvider.notify();
                    },
                    child: const Text("+ Add Task")),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (taskTitle.text.isNotEmpty) {
                taskProvider.taskForm.title = taskTitle.text;
                taskProvider.savedTask
                    .putAt(taskProvider.formIndex, taskProvider.taskForm);
                ScaffoldMessenger.of(context).showSnackBar(
                    MySnackBar.createSnackBar(
                        bgColor: Colors.red,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        text: "Saved",
                        icon: Icons.check));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    MySnackBar.createSnackBar(
                        bgColor: Colors.red,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        text: "Title is a mandatory field",
                        icon: Icons.info));
              }
            },
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }
}
