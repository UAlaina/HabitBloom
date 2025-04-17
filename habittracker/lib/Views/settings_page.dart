import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dailyReminder = false;
  bool weeklyReminder = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Daily Reminder'),
            trailing: Switch(
              value: dailyReminder,
              activeColor: Colors.lightBlue,
              onChanged: (value) {
                setState(() {
                  dailyReminder = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Weekly Reminder'),
            trailing: Switch(
              value: weeklyReminder,
              activeColor: Colors.lightBlue,
              onChanged: (value) {
                setState(() {
                  weeklyReminder = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: darkMode,
              activeColor: Colors.lightBlue,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle change password
            },
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle log out
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }
}