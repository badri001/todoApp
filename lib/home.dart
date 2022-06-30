import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants.dart';
import 'package:todo/custom_snack_bar.dart';
import 'package:todo/task_adapter.dart';
import 'package:todo/task_provider.dart';

import 'list_drawer.dart';

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

    taskProvider.savedTask = await Hive.openBox('myTasks');
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
                children: [
                  Center(
                    child: Text(
                        "Currently there are ${taskProvider.savedTask.length} tasks to do"),
                  ),
                  TextButton(
                      onPressed: () {
                        TaskAdapter data = taskProvider.savedTask.getAt(6);
                        log(data.subTasks.toString());
                      },
                      child: const Text("Print data"))
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
                                    taskProvider.newTask.title = value;
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
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        taskProvider.newTask.subTasks.length,
                                    itemBuilder:
                                        ((BuildContext context, index) {
                                      return ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        leading: Checkbox(
                                          value: taskProvider
                                              .newTask.isDone[index],
                                          onChanged: (bool? value) {
                                            taskProvider.newTask.isDone[index] =
                                                !taskProvider
                                                    .newTask.isDone[index];
                                            taskProvider.notify();
                                          },
                                        ),
                                        title: TextField(
                                          controller: subTasks[index],
                                          onChanged: (value) {
                                            taskProvider.newTask
                                                .subTasks[index] = value;
                                            taskProvider.notify();
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)))),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            taskProvider.newTask.subTasks
                                                .removeAt(index);
                                            taskProvider.newTask.isDone
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
                                        taskProvider.newTask.subTasks.add("");
                                        taskProvider.newTask.isDone.add(false);
                                      });
                                      taskProvider.notify();
                                    },
                                    child: const Text("+ Add Task"))
                              ],
                            ),
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {
                            if (taskTitle.text.isNotEmpty) {
                              var newTask = taskProvider.newTask;
                              newTask.title = taskTitle.text;
                              taskProvider.savedTask.add(newTask);
                              taskProvider.clear();
                              taskProvider.notify();
                              taskTitle.clear();
                              subTasks.clear();
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
