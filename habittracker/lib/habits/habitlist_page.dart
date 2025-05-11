import 'package:flutter/material.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'addhabit_page.dart';
import 'package:habittracker/tasks/tasklist_page.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/models/user_data.dart';
import 'package:habittracker/models/db_service.dart';

class HabitlistPage extends StatefulWidget {
  const HabitlistPage({super.key});

  @override
  State<HabitlistPage> createState() => _HabitlistPageState();
}

class _HabitlistPageState extends State<HabitlistPage> {
  List<Habit>? _habits = [];
  //bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to ensure context is available
    Future.microtask(() => _initializeDb());
  }

  Future<void> _initializeDb() async {
    final docId = Provider.of<UserData>(context, listen: false).docId;

    if (docId == null || docId.isEmpty) {
      print('Error: docId is null or empty');
      setState(() {
        //_isLoading = false;
      });
      return;
    }

    print('Initializing DB with docId: $docId');

    try {
      // Initialize our global DB service
      await DbService().initialize(docId);
      _loadData();
    } catch (e) {
      print('Error initializing database: $e');
      setState(() {
        //_isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      final loadedHabits = await DbService().dbHelper.getHabits();
      setState(() {
        _habits = loadedHabits;
        //_isLoading = false;
      });
      //DEBUG
      print('Loaded ${loadedHabits.length} habits');
      for (var habit in _habits!) {
        print('${habit.toString()}');
      }
    } catch (e) {
      print('Error loading habits: $e');
      setState(() {
        //_isLoading = false;
      });
    }
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


/*
@override
  void initState() {
    super.initState();
    final docId = Provider.of<UserData>(context, listen: false).docId;
    print('testi ${docId}');
    dbHelper = DbHelper(userId: docId);
    print('testi ${dbHelper.userId}');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(docId!)),
    // );
    _loadData();
  }
 */