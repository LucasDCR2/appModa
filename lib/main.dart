// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'database/database_helper.dart'; 
import 'app/home_page.dart';
import 'constants.dart';

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
      theme: ThemeData(
        primarySwatch: customPurple, // Usar o MaterialColor personalizado
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: customPurple, // Define a cor de fundo da AppBar
        ),
      ),
      home: HomePage(trocarTema: _trocarTema),
    );
  }
}