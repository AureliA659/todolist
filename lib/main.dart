import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 91, 52, 158)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My ToDo List '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _task = [];
  final List<bool> _doneTask = [];
  final TextEditingController _textController = TextEditingController();

  void _addTask(String newTask) {
    setState(() {
      _task.add(newTask);
      _doneTask.add(false);
    });
  }

  void _markAsDone(int index) {
    setState(() {
      _doneTask[index] = !_doneTask[index];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _task.removeAt(index);
      _doneTask.removeAt(index);
    });
  }

  void _editTask(int index, String newTask) {
    setState(() {
      _task[index] = newTask;
    });
  }

  void _showTaskDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editController =
            TextEditingController(text: _task[index]);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: editController,
                      decoration: const InputDecoration(labelText: 'Edit task'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.notifications_none),
                          label: "Add a reminder"),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.save),
                        label: 'Save',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.delete),
                        label: 'Delete',
                      ),
                    ],
                    onTap: (int selectedIndex) {
                      if (selectedIndex == 1) {
                        _editTask(index, editController.text);
                      } else if (selectedIndex == 2) {
                        _deleteTask(index);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Enter a task'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _addTask(_textController.text);
                  _textController.clear();
                },
                child: const Text('Add task')),
            const SizedBox(height: 40),
            const Text(
              'List of Tasks:',
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _task.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            _task[index],
                            style: TextStyle(
                              color: _doneTask[index]
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            _showTaskDialog(index);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.done),
                        color: Colors.black,
                        onPressed: () {
                          _markAsDone(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
