import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants.dart';
import 'package:todo/widgets/custom_snack_bar.dart';
import 'package:todo/task_adapter.dart';
import 'package:todo/provider/task_provider.dart';

import '../widgets/list_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskProvider taskProvider;
  var subTasks = <TextEditingController>[];
  bool isLoading = false;
  TextEditingController taskTitle = TextEditingController();
  void getData() async {
    taskProvider = Provider.of<TaskProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    // final documentDirectory = await getApplicationDocumentsDirectory();
    // Hive.init(documentDirectory.path);

    await taskProvider.getSaveTask();
    //taskProvider.savedTask = taskData;
    // taskData.setState(() {
    //   isLoading = false;
    //   if (kDebugMode) {
    //     print("Currently there are ${taskData.length} tasks to do");
    //   }
    // });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpen) {
        if (!isOpen) {
          getData();
        }
      },
      drawer: const ListDrawer(),
      appBar: AppBar(
        title: const Text("Its time TO-DO"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                        "Currently there are ${taskProvider.savedTask.length} tasks to do"),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              isScrollControlled: true,
              context: context,
              builder: (context) => Consumer<TaskProvider>(
                      builder: (BuildContext context, taskProvider, _) {
                    return FractionallySizedBox(
                      heightFactor: 0.83,
                      child: Scaffold(
                        body: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Container(
                                    color: kPrimaryColor,
                                    height: 10,
                                    width: 60,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: taskTitle,
                                  onChanged: (value) {
                                    taskProvider.taskForm.title = value;
                                  },
                                  autocorrect: true,
                                  decoration: const InputDecoration(
                                      hintText: "Garden works",
                                      labelText: "Title",
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "You can list your sub tasks here",
                                  textAlign: TextAlign.left,
                                ),
                                Column(
                                  children: [
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: taskProvider
                                            .taskForm.subTasks.length,
                                        itemBuilder:
                                            ((BuildContext context, index) {
                                          return ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            leading: Checkbox(
                                              value: taskProvider
                                                  .taskForm.isDone[index],
                                              onChanged: (bool? value) {
                                                taskProvider.taskForm
                                                        .isDone[index] =
                                                    !taskProvider
                                                        .taskForm.isDone[index];
                                                taskProvider.notify();
                                              },
                                            ),
                                            title: TextField(
                                              controller: subTasks[index],
                                              onChanged: (value) {
                                                taskProvider.taskForm
                                                    .subTasks[index] = value;
                                                taskProvider.notify();
                                              },
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)))),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                taskProvider.taskForm.subTasks
                                                    .removeAt(index);
                                                taskProvider.taskForm.isDone
                                                    .removeAt(index);
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
                                            taskProvider.taskForm.subTasks
                                                .add("");
                                            taskProvider.taskForm.isDone
                                                .add(false);
                                          });
                                          taskProvider.notify();
                                        },
                                        child: const Text("+ Add Task")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {
                            if (taskTitle.text.isNotEmpty) {
                              var taskForm = taskProvider.taskForm;
                              taskForm.title = taskTitle.text;
                              taskProvider.savedTask.add(taskForm);
                              taskProvider.clear();
                              taskProvider.notify();
                              taskTitle.clear();
                              subTasks.clear();
                              taskProvider.notify();
                              getData();
                              Navigator.of(context).pop();
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
                          child: const Icon(Icons.check),
                        ),
                      ),
                    );
                  }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
