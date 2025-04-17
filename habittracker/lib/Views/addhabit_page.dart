import 'package:flutter/material.dart';

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