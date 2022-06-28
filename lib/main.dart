import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var taskData;

  bool isLoading = false;
  TextEditingController taskTitle = TextEditingController();
  void getData() async {
    setState(() {
      isLoading = true;
    });
    final documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    taskData = await Hive.openBox('myBox');
    setState(() {
      isLoading = false;
      if (kDebugMode) {
        print("Currently there are ${taskData.length} tasks to do");
      }
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
      drawer: Drawer(
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
            const ListTile(
              title: Text("list 1"),
            ),
            const ListTile(
              title: Text("list 2"),
            ),
            const ListTile(
              title: Text("list 3"),
            ),
            ListTile(
              onTap: () => Navigator.pop(context),
              title:
                  const Text("Close", style: TextStyle(color: kPrimaryColor)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Its time TO-DO"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Text("Currently there are ${taskData.length} tasks to do"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              isScrollControlled: true,
              context: context,
              builder: (context) => FractionallySizedBox(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 0,
                                  itemBuilder: ((BuildContext context, index) {
                                    return ListTile(
                                      leading: Checkbox(
                                        value: false,
                                        onChanged: (bool? value) {},
                                      ),
                                      title: const TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)))),
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
                                  onPressed: () {},
                                  child: const Text("+ Add Task"))
                            ],
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(Icons.check),
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
