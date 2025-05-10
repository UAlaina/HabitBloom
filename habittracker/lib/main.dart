import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCs7QYbh0cUdMRuTpnDl-VDmL9GC1HFH48",
      appId: "17345865914",
      messagingSenderId: "17345865914",
      projectId: "habittracker-5c882",
    ),
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