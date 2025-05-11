import 'package:flutter/material.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'package:habittracker/tasks/addtask_page.dart';

class TaskListPage extends StatefulWidget {
  final int habitId;

  const TaskListPage({super.key, required this.habitId});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final DbHelper dbHelper = DbHelper();
  List<Task>? _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedTasks = await dbHelper.getTasks();
      setState(() {
        _tasks = loadedTasks;
      });
    } catch (e) {
      print('Error loading habits: $e');
    }
    for (var habit in _tasks!) {
      print('${habit.toString()}');
    }
    print(_tasks);
    print('\n\n\n\n\n\n\n\n\n\nTEST\n\n\n\n\n\n');
  }

  Future<void> _updateTaskStatus(Task task, int completed) async {
    final newTask = Task(
      id: task.id,
      habitId: task.habitId,
      title: task.title,
      completed: completed,
    );

    try {
      await dbHelper.updateTask(newTask);
      await _loadData();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Room updated successfully')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to updated task: $e')),
      );
    }
  }

  void _navigateToAddTaskPage() async {
    final shouldReload = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage(habitId: widget.habitId)),
    );

    if (shouldReload == true) {
      _loadData();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HABITNAMEHERE'),
      ),
      body: _tasks == null || _tasks!.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _tasks!.length,
        itemBuilder: (context, index) {
          final task = _tasks![index];
          return GestureDetector(
            onTap: () =>
            {
              //_navigateToTaskList(habit.id),
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CHECKBOX
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) async {
                      setState(() {
                        task.completed = value ?? false ? 1 : 0;
                      });
                      await _updateTaskStatus(task, task.completed);
                    },
                  ),
                  //TEXT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (task.completed != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Completed: ${task.completed}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskPage,
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.add),
      ),
    );
  }
}
