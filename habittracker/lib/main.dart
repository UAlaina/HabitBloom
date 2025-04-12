import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Views/splash_screen.dart';

//in json "package_name"
//"package_name": "com.android.habitTracker"

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}