import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tukangnow1/screens/entry_screen.dart';
import 'package:tukangnow1/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TukangNow',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const EntryScreenPage(),
    );
  }
}

