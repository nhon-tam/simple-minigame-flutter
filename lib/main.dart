import 'package:flutter/material.dart';
import 'package:flipcard/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipcard/config.dart';
import 'package:flipcard/register.dart';
import 'package:flipcard/homepage.dart';
import 'package:flipcard/profile.dart';
import 'package:flipcard/result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final configurations = Configurations();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: configurations.apiKey,
      appId: configurations.appId,
      messagingSenderId: configurations.messagingSenderId,
      projectId: configurations.projectId,
      databaseURL: configurations.databaseURL
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minigame',
      home: Result(),
    );
  }
}

