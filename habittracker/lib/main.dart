// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'Views/splash_screen.dart';
//
// //in json "package_name"
// //"package_name": "com.android.habitTracker"
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // initialize the firebase
//   await Firebase.initializeApp(
//       options: FirebaseOptions(
//           apiKey: "AIzaSyCs7QYbh0cUdMRuTpnDl-VDmL9GC1HFH48",
//           appId: "17345865914",
//           messagingSenderId: "17345865914",
//           projectId: "habittracker-5c882"
//       )
//   );
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Habit Tracker',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habittracker/Views/EX_dashboard_page.dart';
import 'package:habittracker/Views/addhabit_page.dart';
import 'package:habittracker/Views/addworkout_page.dart';
import 'package:habittracker/Views/dashboard_page.dart';
import 'package:habittracker/Views/forgotpasswordpage.dart';
import 'package:habittracker/Views/login_page.dart';
import 'package:habittracker/Views/postit_page.dart';
import 'package:habittracker/Views/profile_page.dart';
import 'package:habittracker/Views/settings_page.dart';
import 'package:habittracker/Views/signup_page.dart';
import 'package:habittracker/Views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the firebase
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCs7QYbh0cUdMRuTpnDl-VDmL9GC1HFH48",
          appId: "17345865914",
          messagingSenderId: "17345865914",
          projectId: "habittracker-5c882"
      )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    DashboardPage(), //done
    ForgotPasswordPage(), //done
    AddNewHabitsPage(), //done
    PostItCanvasPage(), //done
    LoginPage(), //done
    ProfilePage(), //done
    SignUpPage(), //done
    SplashScreen(),
    MorningWorkoutPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.password),
            label: 'forgot pass',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add habit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2),
            label: 'post-it',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Signup',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'splash screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics),
            label: 'Work out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
