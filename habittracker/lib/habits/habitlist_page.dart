import 'package:flutter/material.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'addhabit_page.dart';
import 'package:habittracker/tasks/tasklist_page.dart';

class HabitlistPage extends StatefulWidget {
  const HabitlistPage({super.key});

  @override
  State<HabitlistPage> createState() => _HabitlistPageState();
}

class _HabitlistPageState extends State<HabitlistPage> {
  final DbHelper dbHelper = DbHelper();
  List<Habit>? _habits = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedHabits = await dbHelper.getHabits();
      setState(() {
        _habits = loadedHabits;
      });
    } catch (e) {
      print('Error loading habits: $e');
    }
    for (var habit in _habits!) {
      print('${habit.toString()}');
    }
    print(_habits);
    print('\n\n\n\n\n\n\n\n\n\nTEST\n\n\n\n\n\n');
  }

  void _navigateToAddHabitPage() async {
    final shouldReload = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewHabitsPage()),
    );

    if (shouldReload == true) {
      _loadData();
    }
  }


  void _navigateToTaskList(int habitId) async {
    final shouldReload = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskListPage(habitId: habitId)),
    );

    if (shouldReload == true) {
      _loadData();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Habits'),
      ),
      body: _habits == null || _habits!.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _habits!.length,
        itemBuilder: (context, index) {
          final habit = _habits![index];
          return GestureDetector(
            onTap: () =>
            {
              _navigateToTaskList(habit.id),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // if (habit.type != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 4),
                  //     child: Text(
                  //       'Type: ${habit.type}',
                  //       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  //     ),
                  //   ),
                  if (habit.repeatOn != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Repeats: ${habit.repeatOn}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabitPage,
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.add),
      ),
    );
  }
}
