import 'package:flutter/material.dart';
import 'package:habittracker/habits/habitlist_page.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habittracker/models/db_service.dart';

class AddNewHabitsPage extends StatefulWidget {
  const AddNewHabitsPage({super.key});

  @override
  State<AddNewHabitsPage> createState() => _AddNewHabitsPageState();
}

class _AddNewHabitsPageState extends State<AddNewHabitsPage> {
  final DbHelper dbHelper = DbService().dbHelper;
  final TextEditingController nameController = TextEditingController();
  // String? selectedFrequency;
  Map<String, String?> selectedValues = {};

  Future<void> _addHabit() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    final habit = Habit(
      id: 0, //is ignored, should auto increment
      name: nameController.text,
      repeatOn: selectedValues['Frequency'] ?? 'Weekly',
    );
    //DEBUG
    // final room = Room(
    //   id: 0, //should auto increment
    //   name: 'roy',
    //   contactPhone: '1234567890',
    //   ssn: 'irgy7e8pid',
    //   address: 'beans 123st',
    // );

    try {
      //await dbHelper.insertHabit(habit);
      await DbService().dbHelper.insertHabit(habit);
      //should clear all text controllers
      //clear();
      //await _loadRooms();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Habit added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add habit: $e')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habits'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //name
            _buildTextField('Habit Name', nameController),
            SizedBox(height: 16),
            // description
            // _buildTextField('Description', maxLines: 4),
            // SizedBox(height: 16),
            _buildDropdown('Frequency', ['Daily', 'Weekly', 'Monthly', 'Once']),
            SizedBox(height: 16),
            _buildDropdown('Reminder', ['Time', 'Notification']),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _addHabit();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HabitlistPage()),
                  // );
                  Navigator.pop(context, true);
                },
                child: Text('Submit', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  //primary: Colors.grey[600],
                  //onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,  {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildDropdown(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValues[label],
            underline: SizedBox(),
            items: options
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedValues[label] = value;
              });
            },
            hint: Text('Select $label'),
          ),
        ),
      ],
    );
  }

}














/*
class AddNewHabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habits'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Habit Name'),
            SizedBox(height: 16),
            _buildTextField('Description', maxLines: 4),
            SizedBox(height: 16),
            _buildDropdown('Frequency', ['Daily', 'Weekly', 'Monthly']),
            SizedBox(height: 16),
            _buildDropdown('Reminder', ['Time', 'Notification']),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Submit', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  //primary: Colors.grey[600],
                  //onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            items: options
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {},
            hint: Text('Select $label'),
          ),
        ),
      ],
    );
  }
}


 */