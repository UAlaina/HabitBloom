import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCalendarScreen extends StatefulWidget {
  @override
  _HabitCalendarScreenState createState() => _HabitCalendarScreenState();
}

class _HabitCalendarScreenState extends State<HabitCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _tasks = {};

  @override
  void initState() {
    super.initState();
    _loadTasksForMonth(_focusedDay);
  }

  void _loadTasksForMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where(FieldPath.documentId,
        isGreaterThanOrEqualTo: _formatDate(startOfMonth))
        .where(FieldPath.documentId, isLessThanOrEqualTo: _formatDate(endOfMonth))
        .get();

    setState(() {
      _tasks = {
        for (var doc in querySnapshot.docs)
          DateTime.parse(doc.id): List<Map<String, dynamic>>.from(doc['tasks']),
      };
    });
  }

  void _addTask(DateTime date, String name, Color color) async {
    final formattedDate = _formatDate(date);
    final task = {'name': name, 'color': color.value};

    final docRef = FirebaseFirestore.instance.collection('tasks').doc(formattedDate);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({
        'tasks': FieldValue.arrayUnion([task]),
      });
    } else {
      await docRef.set({
        'tasks': [task],
      });
    }

    setState(() {
      if (_tasks[date] != null) {
        _tasks[date]!.add(task);
      } else {
        _tasks[date] = [task];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadTasksForMonth(focusedDay);
            },
            eventLoader: (day) => _tasks[day]?.map((task) => task['name']).toList() ?? [],
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _tasks[date]!.map((task) {
                      final color = Color(task['color']);
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.5),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  );
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: (_tasks[_selectedDay] ?? [])
                  .map((task) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(task['color']),
                ),
                title: Text(task['name']),
              ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _addTaskDialog(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Add Habit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTaskDialog() {
    TextEditingController _taskController = TextEditingController();
    Color _selectedColor = Colors.blue;

    setState(() {}); // To refresh the UI when the selected color changes.

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Add Habit"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(hintText: "Enter Habit"),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildColorOption(Colors.blue, () {
                      setState(() => _selectedColor = Colors.blue);
                    }, _selectedColor == Colors.blue),
                    _buildColorOption(Colors.green, () {
                      setState(() => _selectedColor = Colors.green);
                    }, _selectedColor == Colors.green),
                    _buildColorOption(Colors.orange, () {
                      setState(() => _selectedColor = Colors.orange);
                    }, _selectedColor == Colors.orange),
                    _buildColorOption(Colors.purple, () {
                      setState(() => _selectedColor = Colors.purple);
                    }, _selectedColor == Colors.purple),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Add"),
                onPressed: () {
                  if (_taskController.text.isEmpty) return;
                  _addTask(_selectedDay, _taskController.text, _selectedColor);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorOption(Color color, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 6,
                spreadRadius: 1,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}