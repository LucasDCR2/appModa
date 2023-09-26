// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'database/database_helper.dart'; 
import 'app/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseProvider = DatabaseProvider.instance;
  await databaseProvider.initializeDatabase(); 

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _trocarTema() {
    setState(() {
      _isDarkTheme = !_isDarkTheme; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tonalize',
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(), 
      home: HomePage(trocarTema: _trocarTema, 
      ),
    );
  }
}