import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:habittracker/models/user_data.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/Views/EX_dashboard_page.dart';
import 'package:habittracker/habits/addhabit_page.dart';
import 'package:habittracker/homescreen.dart';
//import 'package:habittracker/views/dashboard_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      var snapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email not found")));
        return;
      }

      var userDoc = snapshot.docs.first;
      if (userDoc['password'] == password) {
        //save docId to Provider
        final docId = userDoc.id;
        Provider.of<UserData>(context, listen: false).setDocId(docId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('docID: ${docId}')),
        );

        Navigator.pushReplacement(
          context,
          //MaterialPageRoute(builder: (context) => const DashboardPage()),
          MaterialPageRoute(builder: (context) => HomeScreen(
            isDarkMode: false,
            toggleDarkMode: () {
              setState(() {
                // Logic to toggle dark mode
              });
            }
          ),
          ),

        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect password")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error occurred during login")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Create a new account'),
            ),
          ],
        ),
      ),
    );
  }
}


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user != null) {
            // User is signed in
            // Initialize user data and DB service
            _initializeUserData(context, user);
            return HomeScreen(
                isDarkMode: false,
                toggleDarkMode: () {
                  setState(() {
                    // Logic to toggle dark mode
                  });
                }
            );
          } else {
            // User is not signed in
            return LoginPage(); // Your login screen
          }
        }

        // Loading state
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<void> _initializeUserData(BuildContext context, User user) async {
    final userData = Provider.of<UserData>(context, listen: false);

    // Set user data in provider
    //Provider.of<UserData>(context, listen: false).setDocId('etsydu');
    userData.setDocId(user.uid);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('user.uid ${user.uid}')),
    );

    try {
      // Initialize DB service with user ID
      await DbService().initialize(user.uid);
      print('DB service initialized for user: ${user.uid}');
    } catch (e) {
      print('Error initializing DB service: $e');
    }
  }

}
