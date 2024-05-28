import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _tasks = [];
  final List<bool> _doneTasks = [];
  final TextEditingController _textController = TextEditingController();
  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.init();
  }

  void _addTask(String newTask) {
    setState(() {
      _tasks.add(newTask);
      _doneTasks.add(false);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _doneTasks[index] = !_doneTasks[index];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _doneTasks.removeAt(index);
    });
  }

  void _editTask(int index, String newTask) {
    setState(() {
      _tasks[index] = newTask;
    });
  }

  void _scheduleReminder(int index, String task) async {
    final DateTime scheduledDate = DateTime.now().add(const Duration(
        seconds: 10)); // For demonstration, set to 10 seconds later
    await _notificationService.scheduleNotification(
        index, 'Reminder', task, scheduledDate);
  }

  void _showTaskDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editController =
            TextEditingController(text: _tasks[index]);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: editController,
                  decoration: const InputDecoration(labelText: 'Edit task'),
                ),
                const SizedBox(height: 20),
                BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_none),
                      label: "Add a reminder",
                    ),
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
                    if (selectedIndex == 0) {
                      _scheduleReminder(index, editController.text);
                    } else if (selectedIndex == 1) {
                      _editTask(index, editController.text);
                    } else if (selectedIndex == 2) {
                      _deleteTask(index);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
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
              child: const Text('Add task'),
            ),
            const SizedBox(height: 40),
            const Text(
              'List of Tasks:',
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            _tasks[index],
                            style: TextStyle(
                              color: _doneTasks[index]
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
                          _toggleTaskCompletion(index);
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
