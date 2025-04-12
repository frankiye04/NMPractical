import 'package:flutter/material.dart';

void main() {
  runApp(ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoList',
      home: TaskPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Task {
  String title;
  String priority;
  bool isDone;

  Task({required this.title, this.priority = 'Medium', this.isDone = false});
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> tasks = [];
  final TextEditingController controller = TextEditingController();
  String selectedPriority = 'Medium';

  void addTask() {
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: text, priority: selectedPriority));
        controller.clear();
        selectedPriority = 'Medium';
      });
    }
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void resetTasks() {
    setState(() {
      tasks.clear();
    });
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDoList'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetTasks,
            tooltip: 'Reset List',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'New Task'),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: ['High', 'Medium', 'Low']
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPriority = value);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTask,
                  tooltip: 'Add Task',
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text('No tasks added yet.'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(
                                task.isDone
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                              ),
                              onPressed: () => toggleTask(index),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text('Priority: ${task.priority}'),
                            trailing: CircleAvatar(
                              backgroundColor: getPriorityColor(task.priority),
                              radius: 6,
                            ),
                            onLongPress: () => deleteTask(index),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
