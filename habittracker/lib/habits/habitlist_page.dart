import 'package:flutter/material.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'addhabit_page.dart';


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Habits'),
      ),
      body: _habits == null || _habits!.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      ) :
      ListView.builder(
          itemCount: _habits!.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Text(_habits![index].id.toString()),
                        //Text(_habits![index].username),
                        Text('Habit'),
                      ],
                    ),
                    SizedBox(height: 20),
                  ]
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddNewHabitsPage()),
          // );
          _navigateToAddHabitPage();
        },
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.add),
      ),
    );
  }
}
